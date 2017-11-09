<?php

use Bitrix\Main\Type\Datetime;
use Bizprofi\CrmExchange\DataManager;
use Bizprofi\CrmExchange\Importer\ImporterFactory;
use Bizprofi\CrmExchange\Model;
use Bizprofi\CrmExchange\Service\EntityType;
use Bizprofi\CrmExchange\Upserter\UpserterFactory;
use Bizprofi\CrmExchange\XmlReader\DocumentReader;

$row = DataManager\NodeTable::getRowById(1);
$node = new Model\Node($row);

$row = DataManager\ImportHistoryTable::query()
    ->addFilter('=NODE_ID', $node['ID'])    
    ->addFilter('>=DATE' , (new Datetime())->add('-T12H'))
    ->addFilter('=ID', 1778)
    ->addOrder('DATE', 'DESC')
    ->addSelect('ID')
    ->addSelect('DATE')
    ->addSelect('XML_OUTPUT')
    ->exec()
    ->fetch();

$reader = new DocumentReader(3.01);
$reader->XML($row['XML_OUTPUT']);
$reader->skipNodes(0);

$errors = [];
foreach ($reader->getNodes() as $hash => $fields) {
    $_SESSION['BIZPROFI_CRMEXCHANGE']['PROCESS_NODES']++;

    $importer = ImporterFactory::createByBusinessTransaction($fields['BUSINESS_TRANSACTION'], $hash, $fields);

    $importer->setSchemaVerion(3.01);
    $importer->setNode($node);

    $dealFields = $importer->prepareDocuments();

    if ((int) $dealFields['ID'] !== 14647) {
        continue;
    }

    try {
        $result = UpserterFactory::upsert(EntityType::DEAL_NAME, null, $dealFields, null);
    } catch (\Exception $ex) {
        $result->addError(new Error($ex->getMessage(), 'error_exception'));
    }

    var_dump($result);    
}
