<?php

use Bizprofi\MarsysPromotion\DataManager\Promotion as PromotionManager;

$metricId = 36;

$metric = PromotionManager\MetricTable::getRowById($metricId);
$result = PromotionManager\MetricTable::upsert($metric, $metric);
if (!$result->isSuccess()) {
    return var_dump($result->getErrorMessages());
}

$metricDeal = PromotionManager\MetricDealTable::query()
    ->addSelect('*')
    ->addFilter('=METRIC_ID', $metricId)
    ->setLimit(1)
    ->exec()
    ->fetch();

$result = PromotionManager\MetricDealTable::upsert($metricDeal, $metricDeal);
if (!$result->isSuccess()) {
    return var_dump($result->getErrorMessages());
}

var_dump('It`s ok.');
