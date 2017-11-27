<?php


use Bitrix\Main\Web\DOM;

$document = new DOM\Document();
$document->loadHTML($html);

$tables = $document->querySelectorAll('table');
foreach ($tables as $tableNode) {
    $subTables = $tableNode->querySelectorAll('table');
    if (count($subTables) > 0) {
        continue;
    }

    $rows = $tableNode->querySelectorAll('tr');
    foreach ($rows as $rowNode) {
        $columns = $rowNode->querySelectorAll('td');

        $parsed[] = array_filter([
            'TITLE' => $columns[0] ? $columns[0]->getTextContent(): null,
            'VALUE' => $columns[1] ? $columns[1]->getTextContent(): null,
        ]) ?: null;
    }
}

var_dump(array_filter($parsed));
