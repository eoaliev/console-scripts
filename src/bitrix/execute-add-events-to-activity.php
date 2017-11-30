<?php

use Magnifico\EmailTracker\Model;
use Magnifico\EmailTracker\Parser;
use Bitrix\Main\Loader;
use Bitrix\Main\Web\DOM;

Loader::includeModule('crm');

$activityId = 109;

$fields = \CCrmActivity::getById($activityId);

$rsEvents = GetModuleEvents('crm', 'OnActivityAdd');
while ($arEvent = $rsEvents->Fetch())
{
    ExecuteModuleEventEx($arEvent, array($fields['ID'], &$fields));
}
