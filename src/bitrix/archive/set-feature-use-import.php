<?php
use Realty\DataManager\FeatureTable;
use Realty\DataManager\ImportTable;
use Realty\DataManager\UserTable;
use Realty\Model\User;

$users = UserTable::query()
    ->addFilter('=UF_TYPE', User::TYPE_PROFY)
    ->addSelect('*')
    ->exec();

while ($user = $users->fetch()) {
    $user = User::create($user);

    if (!$user->hasFeature(User::FEATURE_USE_IMPORT)) {
        if ($user->hasCompany()) {
            continue;
        }

        $rows = ImportTable::query()
            ->addFilter('=CREATED_BY', $user['ID'])
            ->exec();

        if ($rows->getSelectedRowsCount() > 0) {
            FeatureTable::add([
                'MODEL' => FeatureTable::MODEL_USER,
                'MODEL_ID' => $user['ID'],
                'FEATURE' => User::FEATURE_USE_IMPORT,
                'OPTIONS' => serialize([]),
            ]);
        }
    }
}