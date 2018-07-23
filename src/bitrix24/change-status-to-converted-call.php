<?php

set_time_limit(90);

if (!defined('CRM_LEAD_STATUS_CONVERTED')) {
    define('CRM_LEAD_STATUS_FROM', 'CONVERTED');
}

if (!defined('CRM_LEAD_STATUS_TO')) {
    define('CRM_LEAD_STATUS_TO', 3);
}

if (!\Bitrix\Main\Loader::includeModule('crm')) {
    echo 'Module crm not install'.PHP_EOL;
    return;
}

if (!\Bitrix\Main\Loader::includeModule('voximplant')) {
    echo 'Module voximplant not install'.PHP_EOL;
    return;
}

$stages = [];
foreach (\Bitrix\Crm\Category\DealCategory::getAllIDs() as $categoryId) {
    $stages[] = \Bitrix\Crm\Category\DealCategory::prepareStageID($categoryId, 'NEW');
}

$rows = \Bitrix\Crm\LeadTable::query()
    ->addSelect('ID')
    ->whereIn('ID', \Bitrix\Crm\DealTable::query()
        ->addSelect('LEAD_ID')
        ->whereIn('STAGE_ID', $stages)
    )
    ->where('STATUS_ID', CRM_LEAD_STATUS_FROM)
    ->where('DATE_CREATE', '<=', new \Bitrix\Main\Type\Datetime('2018.04.16 00:00:00', 'Y.m.d H:i:s'))
    ->where(\Bitrix\Main\Entity\Query::filter()
        ->logic('OR')
        ->whereLike('TITLE', '% - Входящий звонок%')
        ->whereLike('TITLE', '% - Исходящий звонок%')
    )
    ->setLimit(50)
    ->addOrder('ID', 'ASC')
    ->exec();

$dealEntity = new \CCrmDeal(false);
$leadEntity = new \CCrmLead(false);

$leadIds = [];
while ($row = $rows->fetch()) {
    $fields = ['STATUS_ID' => CRM_LEAD_STATUS_TO];
    if (!$leadEntity->update((int) $row['ID'], $fields)) {
        echo 'Fail update lead stage from lead '.intval($row['ID']).PHP_EOL;
        continue;
    }

    $leadIds[] = (int) $row['ID'];
}

$dealRows = \Bitrix\Crm\DealTable::query()
    ->addSelect('ID')
    ->whereIn('STAGE_ID', $stages)
    ->whereIn('LEAD_ID', $leadIds)
    ->exec();

while ($dealRow = $dealRows->fetch()) {
    if (!$dealEntity->delete($dealRow['ID'])) {
        echo 'Fail remove deal '.intval($dealRow['ID']).PHP_EOL;
        continue;
    }
}

echo 'done'.PHP_EOL;
