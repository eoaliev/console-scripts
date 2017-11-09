<?php

use Bitrix\Crm\DealTable;
use Bitrix\Main\Config\Option;
use Bitrix\Main\Db\SqlExpression;
use Bitrix\Main\Loader;
use Bizprofi\CrmExchange\DataManager\ImportEntityTable;
use Bizprofi\CrmExchange\DataManager\ImportHistoryTable;
use Bizprofi\CrmExchange\Service\EntityType;
use Bizprofi\CrmExchange\XmlReader\DocumentReader;

Loader::includeModule('crm');

$getDeal = function ($fields) {
    $accountPrefix = Option::get('sale', '1C_SALE_ACCOUNT_NUMBER_SHOP_PREFIX', '');

    $query = DealTable::query()
        ->addSelect('*')
        ->addSelect('UF_DIRECTION')
        ->setLimit(1);

    $or = [];
    if (!empty($fields['ID'])) {
        $byExternalId = ImportEntityTable::query()
            ->addFilter('=EXTERNAL_ID', $fields['ID'])
            ->addFilter('=ENTITY_TYPE', EntityType::Deal)
            ->addFilter('=NODE_ID', 4)
            ->addFilter('!=ENTITY_ID', null)
            ->addSelect('ENTITY_ID');

        $or[] = ['@ID', new SqlExpression($byExternalId->getQuery())];

        $or[] = ['=UF_XML_ID' => $fields['ID']];
    }

    if (count($or) <= 0) {
        return;
    }

    $or['LOGIC'] = 'OR';
    $query->addFilter(count($query->getFilter()), $or);

    return $query->exec()->fetch();
};

$rows = ImportHistoryTable::query()
    ->addFilter('=NODE_ID', 4)
    ->addSelect('*')
    ->exec();

$connection = DealTable::getEntity()->getConnection();
$ids = [];
$results = [];
$entity = new \CCrmDeal(false);
while ($row = $rows->fetch()) {
    $reader = new DocumentReader(3.01);
    $reader->XML($row['XML_OUTPUT']);

    foreach ($reader->getNodes() as $hash => $fields) {
        if ($row = $getDeal($fields)) {
            $results[] = [$row['ID'], $entity->delete($row['ID'])];
        }

        $connection->queryExecute('
            DELETE FROM `'.ImportEntityTable::getTableName().'` 
            WHERE 
                `NODE_ID`=4 AND 
                `ENTITY_TYPE`="'.EntityType::Deal.'" AND
                `EXTERNAL_ID`="'.$fields['ID'].'"
        ');
    }
}

var_dump($results);