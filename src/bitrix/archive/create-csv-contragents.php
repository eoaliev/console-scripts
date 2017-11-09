<?php

use Bizprofi\CrmExchange\XmlReader\DocumentReader;
use Bizprofi\CrmExchange\XmlWriter\ContractorWriter;

require_once($_SERVER["DOCUMENT_ROOT"] . "/bitrix/modules/main/classes/general/csv_data.php");

$csvFile = $_SERVER['DOCUMENT_ROOT'] . '/upload/restore-contragents.csv';
$fp = fopen($csvFile, 'w+');
@fclose($fp);

$csv = new \CCSVData('R', false);
$csv->SetFieldsType('R');
$csv->SetDelimiter(';');
$csv->SetFirstHeader(true);

$csv->SaveFile($csvFile, ['ID', 'Старое название', 'Новое название', 'Телефоны', 'Email`s', 'ИНН', 'КПП']);

$reader = new DocumentReader(3.01);
$reader->open('/app/www/upload/documents-001.xml');

$i = 0;
foreach ($reader->getNodes() as $hash => $fields) {
    foreach ($fields['CONTRACTORS'] as $contractorFiedls) {
        $phones = [];
        $emails = [];
        foreach ($contractorFiedls['CONTACTS'] as $contact) {
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
            $contractorFiedls['ID'],
            $contractorFiedls['ITEM_NAME'],
            $contractorFiedls['OFICIAL_NAME'] ?: $contractorFiedls['FULL_TITLE'] ?: $contractorFiedls['ITEM_NAME'],
            implode("\n", $phones),
            implode("\n", $emails),
            $contractorFiedls['INN'],
            $contractorFiedls['KPP'],
        ]);
    }

    $i++;
}

var_dump($i);