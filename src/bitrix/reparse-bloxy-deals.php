<?php

use Bitrix\Crm;
use Bitrix\Main\Entity;
use Bitrix\Main\Loader;
use Bitrix\Main\Web\DOM;
use Bitrix\Main\Config;
use Magnifico\Site\Model;
use Magnifico\Site\Parser;

Loader::includeModule('crm');

$activityBindingRows = Crm\ActivityBindingTable::query()
    ->registerRuntimeField('ACTIVITY', new Entity\ReferenceField('ACTIVITY', Crm\ActivityTable::class, [
        'ref.ID' => 'this.ACTIVITY_ID',
    ], [
        'join_type' => 'inner',
    ]))
    ->addFilter('=OWNER_ID', [18984, 18983, 18969, 18968, 18967])
    ->addFilter('=OWNER_TYPE_ID', \CCrmOwnerType::Deal)
    ->addFilter('=ACTIVITY.TYPE_ID', \CCrmActivityType::Email)
    ->addFilter('=ACTIVITY.DIRECTION', \CCrmActivityDirection::Incoming)
    ->addSelect('*')
    ->setLimit(5)
    ->exec();

while ($activityBindingRow = $activityBindingRows->fetch()) {
    $fields = \CCrmActivity::getById($activityBindingRow['ACTIVITY_ID']);
    if (empty($fields)) {
        continue;
    }

    $activity = Model\Activity::create($fields);
    $parser = Parser\BloxyNovember::create($fields['DESCRIPTION']);

    $parsedFields = $parser->parse();

    $dealEntity = new \CCrmDeal();
    $companyEntity = new \CCrmCompany();
/*
    $updateDeal = array_filter([
        'TITLE' => $parsedFields['TITLE']['VALUE'] ?: null,
        'COMMENTS' => nl2br($parsedFields['DESCRIPTION']['VALUE']) ?: null,
        'OPPORTUNITY' => is_numeric(str_replace(' ', '', $parsedFields['BUDGET']['VALUE'])) ? (float) str_replace(' ', '', $parsedFields['BUDGET']['VALUE']): null,
        'ADDITIONAL_INFO' => serialize($parsedFields) ?: null,
        'ORIGINATOR_ID' => 'parser_bloxy_november',
        'ORIGIN_ID' => (string) $parsedFields['EXTERNAL_ID']['VALUE'] ?: null,
    ]);

    if (!empty($updateDeal)) {
        var_dump($dealEntity->update($activityBindingRow['OWNER_ID'], $updateDeal));
    }
*/

    $fm = [];
    if (empty($parsedFields)) {
        foreach ($message['FROM'] as $from) {
            $fm[\CCrmFieldMulti::EMAIL]['n'.(count($fm[\CCrmFieldMulti::EMAIL]) + 1)] = [
                'VALUE' => $from,
                'VALUE_TYPE' => 'WORK',
            ];
        }
    }

    $phone = preg_replace('/[^0-9]/', '', $parsedFields['PHONE']['VALUE']);
    if (is_numeric($phone)) {
        $fm[\CCrmFieldMulti::PHONE]['n'.(count($fm[\CCrmFieldMulti::PHONE]) + 1)] = [
            'VALUE' => $phone,
            'VALUE_TYPE' => 'WORK',
        ];
    }

    do {
        if (!filter_var($parsedFields['EMAIL']['VALUE'], FILTER_VALIDATE_EMAIL)) {
            break;
        }

        $fm[\CCrmFieldMulti::EMAIL]['n'.(count($fm[\CCrmFieldMulti::EMAIL]) + 1)] = [
            'VALUE' => $parsedFields['EMAIL']['VALUE'],
            'VALUE_TYPE' => 'WORK',
        ];
    } while (false);

    $updateCompany = array_filter([
        'TITLE' => $parsedFields['TITLE']['VALUE'] ?: null,
        'ASSIGNED_BY_ID' => (int) Config\Option::get('magnifico.site', 'emailtracker_assigned', (int) $this['RESPONSIBLE_ID'] ?: 1),
        'COMPANY_TYPE' => 'CUSTOMER',
        'INDUSTRY' => 'OTHER',
        'REVENUE' => '0.0',
        'CURRENCY_ID' => 'RUB',
        'EMPLOYEES' => 'EMPLOYEES_1',
        'OPENED' => 'Y',
        'FM' => array_filter($fm) ?: null,
        'COMMENTS' => nl2br($parsedFields['DESCRIPTION']['VALUE']) ?: null,
    ]);

    $emails = [];
    foreach ($updateCompany['FM'][\CCrmFieldMulti::EMAIL] as $fmItem) {
        $emails[] = $fmItem['VALUE'];
    }

    $phones = [];
    foreach ($updateCompany['FM'][\CCrmFieldMulti::PHONE] as $fmItem) {
        $phones[] = $fmItem['VALUE'];
    }

    if (!($companyId = $activity->getCompanyId($emails, $phones))) {
        $companyId = $companyEntity->Add($updateCompany);
    }

    if (empty($companyId)) {
        var_dump($companyId);
        return;
    }

    $updateDeal = ['COMPANY_ID' => $companyId];

    var_dump($dealEntity->update($activityBindingRow['OWNER_ID'], $updateDeal));
}
