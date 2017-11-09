<?php

use Bitrix\Main\Loader;
use Realty\DataManager\ArticleTable;

if (!Loader::includeModule('iblock')) {
    return var_dump('Not include iblock');
}

$rows = ArticleTable::query()
    ->addFilter('=IBLOCK.CODE', 'library')
    ->addFilter('=CREATED_BY', 2599)
    ->addFilter('=AUTHOR_NAME.VALUE', false)
    ->addSelect('ID')
    ->addSelect('IBLOCK_ID')
    ->exec();

$iter = 0;
$elementManager = new \CIBlockElement();
while ($row = $rows->fetch()) {
    if ($elementManager->update($row['ID'], ['CREATED_BY' => 2183, 'TIMESTAMP_X' => false])) {
        CIBlockElement::SetPropertyValuesEx($row['ID'], $row['IBLOCK_ID'], array('AUTHOR_NAME' => 'Редакция RegionalRealty.ru'));
        var_dump(sprintf('Update library element %d', $row['ID']));
    } else {
        var_dump($elementManager->LAST_ERROR);
    }
}
