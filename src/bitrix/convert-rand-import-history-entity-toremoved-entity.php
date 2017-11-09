<?php

use Bizprofi\CrmExchange\DataManager;

$row = DataManager\ImportHistoryTable::query()
    ->addSelect('*')
    ->setLimit(1)
    ->exec()
    ->fetch();

unset($row['ID']);

$row['XML_OUTPUT'] = str_replace('<ПометкаУдаления>false</ПометкаУдаления>', '<ПометкаУдаления>true</ПометкаУдаления>', $row['XML_OUTPUT']);

$result = DataManager\ImportHistoryTable::add($row);

var_dump($result->getId(), $result->isSuccess(), $result->getErrorMessages());