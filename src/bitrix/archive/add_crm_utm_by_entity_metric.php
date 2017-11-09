<?php

use Bitrix\Crm\UtmTable;
use Bitrix\Main\Loader;
use Bizprofi\MarsysPromotion\DataManager\DealMetricTable;
use Bizprofi\MarsysPromotion\DataManager\LeadMetricTable;

if (!Loader::includeModule('crm')) {
    var_dump('Not load crm');
    return;
}

$entities = [];

$entities[\CCrmOwnerType::Deal] = DealMetricTable::query()
    ->addFilter('!=UTM', null)
    ->addSelect('DEAL_ID', 'ELEMENT_ID')
    ->addSelect('UTM')
    ->exec();

$entities[\CCrmOwnerType::Lead] = LeadMetricTable::query()
    ->addFilter('!=UTM', null)
    ->addSelect('LEAD_ID', 'ELEMENT_ID')
    ->addSelect('UTM')
    ->exec();

foreach ($entities as $entityType => $rows) {
    while ($row = $rows->fetch()) {
        if (!($metricUtms = $row['UTM'])) {
            var_dump('Empty metric utm', $row);
            continue;
        }

        $utmRows = UtmTable::query()
            ->addFilter('=ENTITY_TYPE_ID', $entityType)
            ->addFilter('=ENTITY_ID', $row['ELEMENT_ID'])
            ->addSelect('CODE')
            ->exec();

        $exists = [];
        while ($utmRow = $utmRows->fetch()) {
            $exists[] = $utmRow['CODE'];
        }

        $codemap = [
            UtmTable::ENUM_CODE_UTM_SOURCE => 'SOURCE',
            UtmTable::ENUM_CODE_UTM_MEDIUM => 'MEDIUM',
            UtmTable::ENUM_CODE_UTM_CAMPAIGN => 'CAMPAIGN',
            UtmTable::ENUM_CODE_UTM_CONTENT => 'CONTENT',
            UtmTable::ENUM_CODE_UTM_TERM => 'TERM',
        ];

        $updates = [];
        $adds = [];
        foreach ($codemap as $code => $alias) {
            if (in_array($code, $exists, true)) {
                $updates[$code] = $metricUtms[$alias];
                continue;
            }

            $adds[$code] = $metricUtms[$alias];
        }

        if (!empty($updates)) {
            UtmTable::updateEntityUtmFromFields($entityType, $row['ELEMENT_ID'], $updates);
        }

        if (!empty($adds)) {
            UtmTable::addEntityUtmFromFields($entityType, $row['ELEMENT_ID'], $adds);
        }
    }
}

var_dump('Success add');
