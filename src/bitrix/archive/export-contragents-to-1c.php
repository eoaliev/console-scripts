<?php

use Bitrix\Main\Loader;
use Bitrix\Main\Entity\ReferenceField;
use Bitrix\Crm\CompanyTable;
use Bitrix\Main\Type\Date;
use Bizprofi\CrmExchange\Collection\CompanyCollection;
use Bizprofi\CrmExchange\Model;
use Bizprofi\CrmExchange\DataManager\{NodeTable, ImportEntityTable};
use Bizprofi\CrmExchange\XmlWriter\ContractorWriter;

Loader::includeModule('crm');
Loader::includeModule('bizprofi.crmexchange');

$source = new \XmlWriter();
$writer = new ContractorWriter($source, 3.01);

$source->openURI('/app/www/upload/export-contragents.xml');
$writer->writeHeader();

foreach ([1, 2] as $nodeId) {
    $query = CompanyTable::query()
        ->registerRuntimeField('IMPORT_ENTITY', new ReferenceField(
            'IMPORT_ENTITY', 
            ImportEntityTable::class, 
            ['this.UF_XML_ID' => 'ref.EXTERNAL_ID']
        ))
        ->addFilter('>=DATE_CREATE', (new Date('18.06.2017', 'd.m.Y')))
        ->addFilter('<=DATE_CREATE', (new Date('20.06.2017', 'd.m.Y')))
        ->addFilter('!=UF_XML_ID', false)
        ->addFilter('=IMPORT_ENTITY.NODE_ID', $nodeId)
        ->addSelect('*')
        ->addSelect('UF_XML_ID')
        ->addOrder('ID', 'ASC');

    $row = NodeTable::getRowById($nodeId);
    $collection = new CompanyCollection($query, false, false, Model\Node::create($row));
    $collection->exec();

    foreach ($collection->toXml(3.01) as $document) {
        $writer->writeNext($document);
    }
}

$writer->writeFooter();