<?php

use Bitrix\Crm\DealTable;
use Bitrix\Main\Loader;
use Bizprofi\MarsysPromotion\DataManager\Promotion\MetricTable;
use Bizprofi\MarsysPromotion\Model;

Loader::includeModule('crm');

$metrics = MetricTable::prepareItemsByJson([
    1500243874 => [
        'ya_client_id' => '',
        'ga_user_id' => '',
        'ga_client_id' => '1039491906.1499948513',
        'referrer' => 'https://www.google.ru/',
        'entry' => 'https://matras-strong.ru/catalog/matrases/',
        'platform' => 'Linux',
        'device' => 'desktop',
        'utm' => [
            'source' => 'google',
            'medium' => 'cpc',
            'campaign' => 'Матрасы Краснодар',
            'content' => '19856',
            'term' => 'купить матрас в Краснодаре',
        ],
        'browser' => [
            'name' => 'chrome',
            'version' => '56.0.2924.87',
        ],
        'screen' => [
            'width' => '1366',
            'height' => '768',
            'format' => '16:9',
        ],
        'session_end' => 1500243974,
    ],
    1500244874 => [
        'ya_client_id' => '',
        'ga_user_id' => '',
        'ga_client_id' => '1039491906.1499948513',
        'referrer' => 'https://www.google.ru/',
        'entry' => 'https://matras-strong.ru/catalog/dresses/',
        'platform' => 'Linux',
        'device' => 'desktop',
        'utm' => [
            'source' => 'google',
            'medium' => 'cpc',
            'campaign' => 'Кровати Краснодар',
            'content' => '19857',
            'term' => 'купить кровать в Краснодаре',
        ],
        'browser' => [
            'name' => 'chrome',
            'version' => '56.0.2924.87',
        ],
        'screen' => [
            'width' => '1366',
            'height' => '768',
            'format' => '16:9',
        ],
        'session_end' => 1500244974,
    ],
]);

$row = DealTable::getRowById(1838);

$deal = Model\Deal::create($row);
$result = $deal->appendMetrics($metrics, 'https://matras-strong.ru/catalog/matras-s-poduskoi/');
var_dump($result->isSuccess(), $result->getErrorMessages(), $result->getData());