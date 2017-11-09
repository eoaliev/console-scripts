<?php
use Realty\DataManager\ExportOfferTable;
use Realty\DataManager\OfferTable;
use Realty\XmlWriter\WriterFactory;

$rows = ExportOfferTable::query()
    //->addFilter('=XML_CONTENT', false)
    ->addSelect('*')
    ->addSelect('EXPORT.FORMAT', 'FORMAT')
    ->exec()
    ->fetchAll();
/*
$results = [];
foreach ($rows as $row) {
    $writer = WriterFactory::create($row['FORMAT']);
    $offer = OfferTable::query()
        ->addFilter('=ID', $row['OFFER_ID'])
        ->addSelect('*')
        ->setLimit(1)
        ->exec()
        ->fetch();

    $writer->openMemory();
    $writer->writeNext($offer);
    $xml = $writer->outputMemory();

    $result = ExportOfferTable::update($row['ID'], ['XML_CONTENT' => $xml]);
    $results[] = $result->isSuccess();
}*/

var_dump($rows);