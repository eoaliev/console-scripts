<?php

use Bitrix\Crm\ExternalSaleTable;
use Bitrix\Main\Loader;
use Bitrix\Main\Text;
use Bizprofi\MarsysPromotion\DataManager\Promotion\MetricDealTable;
use Bizprofi\MarsysPromotion\DataManager\Promotion\MetricTable;
use Bizprofi\MarsysPromotion\Model;

Loader::includeModule('crm');

$rows = \CCrmDeal::getList([], [
    '>ORIGINATOR_ID' => 0,
    '!ADDITIONAL_INFO' => null,
]);

while ($row = $rows->fetch()) {
    $externalSale = ExternalSaleTable::getRowById((int) $row['ORIGINATOR_ID']);
    if (empty($externalSale)) {
        var_dump('External sale not found', [__FILE__, __LINE__, 'DEAL_ID' => $row['ID'], 'EXTERNAL_SALE_ID' => $fields['ORIGINATOR_ID']]);
        continue;
    }

    if (MetricDealTable::existsForDeal((int) $row['ID'])) {
        var_dump('Metric deal is exists', [__FILE__, __LINE__, 'DEAL_ID' => $row['ID']]);
        continue;
    }

    $additionalInfo = unserialize($row['ADDITIONAL_INFO']);
    if (empty($additionalInfo['B_MP_METRICS'])) {
        var_dump('Metrics is empty', [__FILE__, __LINE__, 'DEAL_ID' => $row['ID']]);
        continue;
    }

    if (!($metrics = json_decode($additionalInfo['B_MP_METRICS'], true))) {
        var_dump('Fail decode metrics', [__FILE__, __LINE__, 'DEAL_ID' => $row['ID']]);
        continue;
    }

    $metrics = Text\Encoding::convertEncoding($metrics, 'UTF-8', 'windows-1251');
    $metrics = MetricTable::prepareItemsByJson($metrics);

    $deal = Model\Deal::create($row);
    $result = $deal->appendMetrics($metrics, ($additionalInfo['B_MP_TARGET'] ?: ''));
    if (!$result->isSuccess()) {
        var_dump(implode(' | ', $result->getErrorMessages()), [
            __FILE__,
            __LINE__,
            'DEAL_ID' => $row['ID'],
            'METRICS' => $metrics,
            'TARGET' => $additionalInfo['B_MP_TARGET'],
        ]);
        continue;
    }

    foreach (['B_MP_METRICS', 'B_MP_TARGET'] as $key) {
        unset($additionalInfo[$key]);
    }

    $updateFields = ['ADDITIONAL_INFO' => serialize($additionalInfo)];
    $dealEntity = new \CCrmDeal(false);
    $dealEntity->Update($row['ID'], $updateFields);
    var_dump('success set metrics');
}