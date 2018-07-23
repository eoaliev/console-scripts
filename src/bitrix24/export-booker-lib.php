<?php

$rows = \Magnifico\Booker\ResourceTable::query()
    ->setSelect(['ID', 'TITLE', 'AUTHOR', 'AVAILABLE_QUANTITY'])
    ->where('TYPE', \Magnifico\Booker\ResourceTable::TYPE_BOOK)
    ->exec();

$csv = [];
$csv[] = implode(';', ['ID книги в библиотеке', 'Ссылка на книгу', 'Название', 'Автор', 'ISBN', 'Количество']);
while ($row = $rows->fetch()) {
    $csv[] = implode(';', [
        $row['ID'],
        \CComponentEngine::makePathFromTemplate(
            \Bitrix\Main\Config\Option::get('magnifico.booker', 'path_to_resource_detail'),
            ['ELEMENT_ID' => $row['ID']]
        ),
        $row['TITLE'],
        $row['AUTHOR'],
        '',
        $row['AVAILABLE_QUANTITY'],
    ]);
}

echo implode(PHP_EOL, $csv);
