<?php

use Bitrix\Crm\DealTable;
use Bitrix\Main\Loader;
use Bizprofi\CrmExchange\DataManager\ImportEntityTable;
use Bizprofi\CrmExchange\Service\EntityType;

Loader::includeModule('crm');

$rows = DealTable::query()
    ->addFilter('=UF_DIRECTION', [28, 29])
    ->addSelect('ID')
    ->addSelect('UF_XML_ID')
    ->addSelect('UF_DIRECTION')
    ->addOrder('ID', 'ASC')
    ->exec();

$selectedRowsCount = $rows->getSelectedRowsCount();
$deletionCount = 0;
$errors = [];
$entity = new \CCrmDeal(false);
$connection = DealTable::getEntity()->getConnection();
while ($row = $rows->fetch()) {
    if (!$entity->delete($row['ID'])) {
        $errors[] = 'Empty delete '.$row['ID'];
    } else {
        $deletionCount++;
    }

    $query = '
        DELETE FROM `'.ImportEntityTable::getTableName().'` 
        WHERE 
            `NODE_ID`="'.((int) $row['UF_DIRECTION'] === 28 ? 3: ((int) $row['UF_DIRECTION'] === 29 ? 4: 0)).'" AND 
            `ENTITY_TYPE`="'.EntityType::Deal.'" AND
            `ENTITY_ID`="'.$row['ID'].'"
    ';
    $connection->queryExecute($query);
}

var_dump($selectedRowsCount, $deletionCount, count($errors), $errors);