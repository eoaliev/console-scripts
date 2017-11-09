<?php

use Bitrix\Main\IO;

$lastId = 0;

$toString = function ($value) {
    return "'".$value."'";
};

$values = [];
$directory = new IO\Directory($_SERVER['DOCUMENT_ROOT'].'/upload/livechat/images/');
foreach ($directory->getChildren() as $io) {
    if (!($io instanceof IO\File)) {
        continue;
    }

    $values[] = '('.implode(', ', array_map($toString, [
        'ID' => $GLOBALS['DB']->forSql(++$lastId),
        'MODULE_ID' => 'imopenlines',
        'FILE_SIZE' => $GLOBALS['DB']->forSql($io->getSize()),
        'CONTENT_TYPE' => $GLOBALS['DB']->forSql($io->getContentType()),
        'SUBDIR' => 'livechat/images',
        'FILE_NAME' => $GLOBALS['DB']->forSql($io->getName()),
        'ORIGINAL_NAME' => $GLOBALS['DB']->forSql($io->getName()),
    ])).')';
}

$query = "INSERT INTO `b_file` (`ID`, `MODULE_ID`, `HEIGHT`, `WIDTH`, `FILE_SIZE`, `CONTENT_TYPE`, `SUBDIR`, `FILE_NAME`, `ORIGINAL_NAME`) VALUES ".implode(', ', $values);

$rows = $GLOBALS['DB']->query($query);

echo '<pre>', var_dump($rows), '</pre>';