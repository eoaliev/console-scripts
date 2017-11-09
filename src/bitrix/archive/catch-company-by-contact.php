<?php

use Bitrix\Crm\ContactTable;
use Bitrix\Main\Loader;
use Bizprofi\MarsysPromotion\Model;

Loader::includeModule('crm');

$rows = ContactTable::query()
    ->addFilter('=COMPANY_ID', null)
    ->addSelect('*')
    ->exec();

$failed = 0;
$successed = 0;
while ($row = $rows->fetch()) {
    $contact = Model\Contact::create($row);

    if (!($company = $contact->catchCompany())) {
        $failed++;
        continue;
    }

    $successed++;
}

var_dump($failed, $successed);