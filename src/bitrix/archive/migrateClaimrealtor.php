<?php

use Realty\DataManager\ClaimRealtorTable;
use Realty\DataManager\DealTable;
use Realty\DataManager\UserGroupTable;
use Realty\DataManager\UserTable;
use Realty\Model\ClaimRealtor;
use Realty\Model\Company;
use Realty\Model\User;

$claimrealtorRows = ClaimRealtorTable::query()
    ->addOrder('CREATION_DATE', 'ASC')
    ->addSelect('*')
    ->exec();

var_dump(sprintf('Найдено %d заявок риэлтору.', $claimrealtorRows->getSelectedRowsCount()));

while ($claimrealtorRow = $claimrealtorRows->fetch()) {
    $claimrealtor = ClaimRealtor::create($claimrealtorRow);

    $userGroupRow = UserGroupTable::query()
        ->addFilter('=GROUP.STRING_ID', User::GROUP_CLAIMREALTOR)
        ->addFilter('=USER.UF_LOCALITY', $claimrealtor['LOCATION_LOCALITY'])
        ->addSelect('USER_ID')
        ->setLimit(1)
        ->exec()
        ->fetch();

    if ($userGroupRow === false) {
        var_dump(sprintf('Заявка риэлтору №%d. В данном городе нет администратора заявок.', $claimrealtor['ID']));
        continue;
    }

    $userRow = UserTable::getRowById($userGroupRow['USER_ID']);
    if (empty($userRow)) {
        var_dump(sprintf('Заявка риэлтору №%d. Администратор заявок не найден.', $claimrealtor['ID']));
        continue;
    }

    $user = User::create($userRow);
    $company = $user->getCompany();
    if (!($company instanceof Company)) {
        var_dump(sprintf('Заявка риэлтору №%d. У администратора заявки нет компании.', $claimrealtor['ID']));
        continue;
    }

    $sourceDescriptions = [];
    if ($claimrealtor['TYPE'] === ClaimRealtorTable::TYPE_SALE) {
        $sourceDescriptions[] = 'Тип сделки: Купить';
    } elseif ($claimrealtor['TYPE'] === ClaimRealtorTable::TYPE_RENT) {
        $sourceDescriptions[] = 'Тип сделки: Снять';
    }

    $categoryTitle = ClaimRealtorTable::getCategoryList($claimrealtor['CATEGORY']);
    if (!empty($categoryTitle)) {
        $sourceDescriptions[] = sprintf('Тип недвижимости: %s', $categoryTitle);
    }

    if (!empty($claimrealtor['LOCATION_LOCALITY'])) {
        $sourceDescriptions[] = sprintf('Город: %s', $claimrealtor['LOCATION_LOCALITY']);
    }

    $currencyTitles = [
        'RUB' => 'руб',
        'EUR' => 'евро',
        'USD' => '$',
    ];

    $priceTitles = [];
    if ((int) $claimrealtor['PRICE_FROM'] > 0) {
        $priceTitles[] = sprintf('%d %s', $claimrealtor['PRICE_FROM'], $claimrealtor['PRICE_CURRENCY']);
    }

    if ((int) $claimrealtor['PRICE_TO'] > 0) {
        $priceTitles[] = sprintf('%d %s', $claimrealtor['PRICE_TO'], $claimrealtor['PRICE_CURRENCY']);
    }

    if (!empty($priceTitles)) {
        $sourceDescriptions[] = sprintf('Бюджет: %s', implode(' - ', $priceTitles));
    }

    $fields = [
        'SOURCE_DESCRIPTION' => implode(';', $sourceDescriptions),
        'COMMENT_CREATOR' => $claimrealtor['DESCRIPTION'],
        'CREATED_BY' => $claimrealtor['CREATED_BY'],
        'CREATED_FOR' => $user['ID'],
        'CREATION_DATE' => $claimrealtor['CREATION_DATE'],
        'COMPANY_ID' => $company['ID'],
        'TYPE' => DealTable::TYPE_WIDGET_CLAIMREALTOR,
        'SOURCE' => DealTable::SOURCE_REGIONALREALTY,
    ];

    if ($claimrealtor['STATUS'] === ClaimRealtorTable::STATUS_UNCORRECT) {
        $fields['NEXT_STEP'] = DealTable::STEP_INCORRECT_DEAL;
    } else {
        $fields['NEXT_STEP'] = DealTable::STEP_NEW_DEAL;
    }

    $contactFields = [
        'CREATED_BY' => $user['ID'],
        'NAME' => $claimrealtor['CREATED_NAME'],
        'PHONES' => [
            $claimrealtor['CREATED_PHONE'],
        ],
    ];

    $contactRow = ContactTable::query()
        ->addFilter('=CREATED_BY', (int) $contactFields['CREATED_BY'])
        ->addFilter('=NAME', (string) $contactFields['NAME'])
        ->addFilter('=%PHONES', sprintf('%%%s%%', $contactFields['PHONES'][0]))
        ->addSelect('ID')
        ->setLimit(1)
        ->exec()
        ->fetch();

    if ($contactRow === false) {
        $result = ContactTable::add(array_filter($contactFields));
        if (!$result->isSuccess()) {
            var_dump(sprintf('Заявка риэлтору №%d. Добавление контакта. %s.', $claimrealtor['ID'], $result->getErrors()));
            continue;
        }

        $fields['CONTACT_ID'] = $result->getId();
    } else {
        $fields['CONTACT_ID'] = (int) $contactRow['ID'];
    }

    $result = DealTable::add($fields);
    if (!$result->isSuccess()) {
        var_dump(sprintf('Заявка риэлтору №%d. Добавление заявки %s.', $claimrealtor['ID'], $result->getErrors()));
        continue;
    }

    var_dump('Заявка успешно добавлена', $result->getId());
}
