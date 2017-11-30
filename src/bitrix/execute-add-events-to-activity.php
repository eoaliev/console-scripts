<?php

use Bitrix\Main\Loader;

Loader::includeModule('crm');

$activityId = 109;

$fields = \CCrmActivity::getById($activityId);

$rsEvents = GetModuleEvents('crm', 'OnActivityAdd');
while ($arEvent = $rsEvents->Fetch())
{
    ExecuteModuleEventEx($arEvent, array($fields['ID'], &$fields));
}
