<?php

use Bitrix\Main\Loader;
use Bitrix\Crm\ContactTable;

Loader::includeModule('crm');

$entity = new \CCrmContact(false);
$rows = $entity->getList(['ID', 'ASC'], [
    '%FULL_NAME' => 'anonymous@crmclient.com',
    '=ORIGINATOR_ID' => 1,
], ['ID', 'FULL_NAME']);

while ($row = $rows->fetch()) {
    $name = preg_replace([
        '/942#anonymous@crmclient.com#/i',
        '/(\()([0-9 +()-]*)(\)?)/i',
    ], ['', ''], $row['FULL_NAME']);

    $name = trim($name);
    if (empty($name)) {
        $name = 'Без имени';
    }

    $fields = ['FULL_NAME' => $name, 'LAST_NAME' => $name];
    $result = $entity->update($row['ID'], $fields);
    echo '<pre>', var_dump($result, $entity->LAST_ERROR), '</pre>';
}