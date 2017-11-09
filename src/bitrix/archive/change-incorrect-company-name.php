<?php

use Bitrix\Main\Loader;

Loader::includeModule('crm');

$entity = new \CCrmCompany(false);
$rows = $entity->getList(['ID', 'ASC'], [
    '%TITLE' => 'anonymous@crmclient.com',
], ['ID', 'TITLE']);

while ($row = $rows->fetch()) {
    $name = preg_replace([
        '/942#anonymous@crmclient.com#/i',
        '/(\()([0-9 +()-]*)(\)?)/i',
    ], ['', ''], $row['TITLE']);

    $name = trim($name);
    if (empty($name)) {
        $name = 'Без имени';
    }

    $fields = ['TITLE' => $name];
    // $result = $entity->update($row['ID'], $fields);
    echo '<pre>', var_dump($row['ID'], $fields), '</pre>';
}