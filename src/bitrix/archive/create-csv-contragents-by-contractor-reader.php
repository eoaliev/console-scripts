<?php

use Bizprofi\CrmExchange\XmlReader\ContractorReader;
use Bizprofi\CrmExchange\XmlWriter\ContractorWriter;

require_once($_SERVER["DOCUMENT_ROOT"] . "/bitrix/modules/main/classes/general/csv_data.php");

$csvFile = $_SERVER['DOCUMENT_ROOT'] . '/upload/2017-05-19T10-46-46-restore-contragents.csv';
$fp = fopen($csvFile, 'w+');
@fclose($fp);

$csv = new \CCSVData('R', false);
$csv->SetFieldsType('R');
$csv->SetDelimiter(';');
$csv->SetFirstHeader(true);

$csv->SaveFile($csvFile, ['ID', 'Старое название', 'Новое название', 'Телефоны', 'Email`s', 'ИНН', 'КПП']);

$reader = new ContractorReader();
$reader->open('/app/www/upload/contragents-001.xml');

$i = 0;
foreach ($reader->getNodes() as $hash => $fields) {
    $phones = [];
    $emails = [];
    foreach ($fields['CONTACTS'] as $contact) {
        $contacts = explode(',', $contact['VALUE']);
        foreach ($contacts as $contactValue) {
            if ($contact['TYPE'] === ContractorWriter::getContactEmailTypeValue(3.01)) {
                $emails[] = trim($contactValue);
                continue;
            }

            if ($contact['TYPE'] === ContractorWriter::getContactPhoneTypeValue(3.01)) {
                $phones[] = trim($contactValue);
                continue;
            }
        }
    }

    $csv->SaveFile($csvFile, [
        $fields['ID'],
        $fields['ITEM_NAME'],
        $fields['OFICIAL_NAME'] ?: $fields['FULL_TITLE'] ?: $fields['ITEM_NAME'],
        implode("\n", $phones),
        implode("\n", $emails),
        $fields['INN'],
        $fields['KPP'],
    ]);
    $i++;
}

var_dump($i);