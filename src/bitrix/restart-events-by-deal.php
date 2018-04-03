<?php

use Bitrix\Main\Loader;
use Bizprofi\MarsysPromotion\EventSubscriber;

if (!Loader::includeModule('crm')) {
    return var_dump('crm is not include');
}

$rows = \CCrmDeal::getList(['ID' => 'DESC'], ['COMPANY_ID' => null]);
while ($fields = $rows->fetch()) {
    // var_dump($fields);
    // $afterEvents = GetModuleEvents('crm', 'OnAfterCrmDealAdd');
    // while ($arEvent = $afterEvents->Fetch()) {
    //     ExecuteModuleEventEx($arEvent, array(&$fields));
    // }

    $subscriber = new EventSubscriber\CrmSubscriber();
    var_dump($subscriber->onAfterDealAddCatchCompany($fields));
}


