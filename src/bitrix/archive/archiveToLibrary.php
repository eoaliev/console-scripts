<?php

use Bitrix\Iblock\ElementTable;
use Bitrix\Main\Config\Option;
use Bitrix\Main\Loader;
use Bitrix\Main\Type\Datetime;

if (!Loader::includeModule('iblock')) {
    return var_dump('Not include iblock');
}

$translitParams = [
   'max_len' => '100',
   'change_case' => 'L',
   'replace_space' => '-',
   'replace_other' => '-',
   'delete_repeat_replace' => 'true',
   'use_google' => 'false',
]; 

$rows = ElementTable::query()
    ->addFilter('=IBLOCK_ID', 2)
    ->addSelect('ID')
    ->addSelect('NAME')
    ->addSelect('PREVIEW_TEXT')
    ->addSelect('DETAIL_TEXT')
    ->addSelect('DETAIL_PICTURE')
    ->exec();

$iter = 0;
$elementManager = new \CIBlockElement();
while ($row = $rows->fetch()) {
    $hour = rand(10, 19);
    $minute = rand(1, 59);
    $second = rand(1, 59);

    $passed = 980 - (6 * $iter++);
    $date = (new Datetime())->add(sprintf('-%dD', $passed))->setTime($hour, $minute, $second);

    $row['DATE_ACTIVE_FROM'] = $date;
    $row['TIMESTAMP_X'] = $date;
    $row['DATE_CREATE'] = $date;
    $row['ACTIVE'] = 'Y';
    $row['CODE'] = \CUtil::translit($row['NAME'], 'ru' , $translitParams);
    $row['IBLOCK_SECTION_ID'] = 6;
    $row['PREVIEW_TEXT_TYPE'] = 'html';
    $row['DETAIL_TEXT_TYPE'] = 'html';
    $row['IBLOCK_ID'] = Option::get('realty', 'LIBRARY_IBLOCK_ID');

    $oldElementId = (int) $row['ID'];
    unset($row['ID']);
    if ($newElementId = $elementManager->add($row)) {
        var_dump(sprintf('Added new library element %d', $newElementId));
        if ($elementManager->update($oldElementId, ['ACTIVE' => 'N'])) {
            var_dump(sprintf('Archive element %d deactivate', $oldElementId));
        } 
    } else {
        var_dump($elementManager->LAST_ERROR);
    }

    var_dump('-- ___ --');
}
