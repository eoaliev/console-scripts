<?php

use Bitrix\Main\Loader;
use Bitrix\Main\Type\Datetime;
use Bizprofi\MarsysPromotion\DataManager;
use Bizprofi\MarsysPromotion\Model;

var_dump('Start catch channels.', [__FILE__, __LINE__]);

if (!Loader::includeModule('crm')) {
    var_dump('Module "crm" not load', [__FILE__, __LINE__]);
    return;
}

$rows = DataManager\Promotion\MetricTable::query()
    ->addFilter('>CREATION_DATE', new Datetime('21.07.2017 00:00:00', 'd.m.Y H:i:s'))
    ->addSelect('*')
    ->addOrder('CREATION_DATE', 'ASC')
    ->exec();

while ($row = $rows->fetch()) {
    $result = Model\Promotion\Metric::create($row)->processCatchChannel(true);
    if (!$result->isSuccess()) {
        var_dump(implode(' | ', $result->getErrorMessages()), [__FILE__, __LINE__, $row['ID']]);
        continue;
    }

    var_dump('Success catch channel after add metric.', [__FILE__, __LINE__, $row['ID']]);
}

var_dump('Finish catch channels.', [__FILE__, __LINE__]);