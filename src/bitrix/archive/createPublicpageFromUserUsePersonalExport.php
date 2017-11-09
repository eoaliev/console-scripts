<?php
use Realty\DataManager\PersonalExportTable;
use Realty\DataManager\CompanyTable;
use Realty\DataManager\UserCompanyTable;
use Realty\DataManager\UserTable;
use Realty\Model\PersonalExport;
use Realty\Model\User;
use Realty\Model\Company;

$rows = PersonalExportTable::query()
    ->addGroup('CREATED_BY')
    ->addSelect('CREATED_BY')
    ->exec();

while ($row = $rows->fetch()) {
    $row = UserTable::getRowById($row['CREATED_BY']);

    $user = User::create($row);

    $ids = array_map(
        function ($row) {
            return $row['PUBLICPAGE_ID'];
        },
        UserCompanyTable::query()
            ->addSelect('PUBLICPAGE_ID')
            ->addFilter('=USER_ID', $user['ID'])
            ->exec()
            ->fetchAll()
    );

    if (!empty($ids)) {
        $pages = array_map(
            function ($row) {
                return Company::create($row);
            },
            CompanyTable::query()
                ->addSelect('*')
                ->addFilter('=ID', $ids)
                ->exec()
                ->fetchAll()
        );

        $companies = array_filter($pages, function ($company) use ($user) {
            return $company->isOwner($user);
        });
    }
    
    if (is_array($companies) && count($companies) > 0) {
        var_dump(sprintf('Пользователь %s уже имеет компанию.', $user->getFullName()));
        continue;
    }

    $result = CompanyTable::add([
        'NAME' => 'Название компании',
        'CONTACT_PHONE' => $user['WORK_PHONE'],
        'CONTACT_EMAIL' => $user['EMAIL'],
        'CREATED_BY' => $user['ID'],
    ]);

    if (!$result->isSuccess()) {
        var_dump($result->getErrorMessages());
        continue;
    }

    var_dump(sprintf('Для пользователя %s создана новая компания %d.', $user->getFullName(), $result->getId()));
}