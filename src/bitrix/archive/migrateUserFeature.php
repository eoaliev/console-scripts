<?php
use Realty\DataManager\FeatureTable;
use Realty\DataManager\ImportTable;
use Realty\DataManager\PersonalExportTable;
use Realty\DataManager\PublicpageTable;
use Realty\DataManager\UserTable;
use Realty\Model\User;

$users = UserTable::query()
    ->addFilter('=UF_TYPE', User::TYPE_PROFY)
    ->addSelect('*')
    ->exec();

while ($user = $users->fetch()) {
    $user = User::create($user);

    if (!$user->hasFeature(User::FEATURE_USE_IMPORT)) {
        $rows = ImportTable::query()
            ->addFilter('=USER_ID', $user['ID'])
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

    if (!$user->hasFeature(User::FEATURE_USE_ADVANCED_OFFER)) {
        FeatureTable::add([
            'MODEL' => FeatureTable::MODEL_USER,
            'MODEL_ID' => $user['ID'],
            'FEATURE' => User::FEATURE_USE_ADVANCED_OFFER,
            'OPTIONS' => serialize([
                User::SUB_FEATURE_USE_ME_OFFER_FILTER => true,
                User::SUB_FEATURE_USE_ME_OFFER_GROUP => true,
                User::SUB_FEATURE_USE_ME_OFFER_STATUS => true,
            ]),
        ]);
    }

    if (!$user->hasFeature(User::FEATURE_USE_JURIST)) {
        if ($user->inGroup('jurist')) {
            FeatureTable::add([
                'MODEL' => FeatureTable::MODEL_USER,
                'MODEL_ID' => $user['ID'],
                'FEATURE' => User::FEATURE_USE_JURIST,
                'OPTIONS' => serialize([]),
            ]);
        }
    }

    if (!$user->hasFeature(User::FEATURE_USE_RATER)) {
        if ($user->inGroup('rater')) {
            FeatureTable::add([
                'MODEL' => FeatureTable::MODEL_USER,
                'MODEL_ID' => $user['ID'],
                'FEATURE' => User::FEATURE_USE_RATER,
                'OPTIONS' => serialize([]),
            ]);
        }
    }

    if (!$user->hasFeature(User::FEATURE_USE_REALTOR)) {
        if ($user->inGroup('realtor')) {
            FeatureTable::add([
                'MODEL' => FeatureTable::MODEL_USER,
                'MODEL_ID' => $user['ID'],
                'FEATURE' => User::FEATURE_USE_REALTOR,
                'OPTIONS' => serialize([
                    User::SUB_FEATURE_USE_INDEXING => true,
                ]),
            ]);
        }
    }

    if (!$user->hasFeature(User::FEATURE_USE_PUBLICPAGE)) {
        $rows = PublicpageTable::query()
            ->addFilter('=CREATED_BY', $user['ID'])
            ->exec();

        if ($rows->getSelectedRowsCount() > 0) {
            FeatureTable::add([
                'MODEL' => FeatureTable::MODEL_USER,
                'MODEL_ID' => $user['ID'],
                'FEATURE' => User::FEATURE_USE_PUBLICPAGE,
                'OPTIONS' => serialize([]),
            ]);
        }
    }

    if (!$user->hasFeature(User::FEATURE_USE_PERSONAL_EXPORT)) {
        $rows = PersonalExportTable::query()
            ->addFilter('=CREATED_BY', $user['ID'])
            ->exec();

        if ($rows->getSelectedRowsCount() > 0) {
            FeatureTable::add([
                'MODEL' => FeatureTable::MODEL_USER,
                'MODEL_ID' => $user['ID'],
                'FEATURE' => User::FEATURE_USE_PERSONAL_EXPORT,
                'OPTIONS' => serialize([]),
            ]);
        }
    }
}