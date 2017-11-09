<?php

use Realty\DataManager\OfferCollectionTable;
use Realty\DataManager\FavoriteSectionTable;
use Realty\DataManager\FavoriteOfferTable;
use Realty\DataManager\OfferTable;
use Realty\DataManager\UserTable;

$rows = OfferCollectionTable::query()
    ->addSelect('*')
    ->addOrder('CREATION_DATE', 'ASC')
    ->exec();

while ($row = $rows->fetch()) {
    $user = UserTable::getRowById($row['CREATED_BY']);
    if (empty($user)) {
        var_dump('user '.$row['CREATED_BY'].' not found');
        continue;
    }

    $sectionResult = FavoriteSectionTable::add([
        'NAME' => $row['NAME'],
        'CREATION_DATE' => $row['CREATION_DATE'],
        'CREATED_BY' => $row['CREATED_BY'],
        'UUID' => $row['UUID'],
    ]);

    if (!$sectionResult->isSuccess()) {
        var_dump('Not add favorite section');
        continue;
    }

    foreach ($row['OFFER_SET'] as $id) {
        $offer = OfferTable::getRowById($id);
        if (empty($offer)) {
            var_dump('offer '.$id.' not found');
            continue;
        }

        if ($offer['STATUS'] !== OfferTable::STATUS_ACTIVE) {
            var_dump('offer '.$id.' not active');
            continue;
        }

        $result = FavoriteOfferTable::add([
            'OFFER_ID' => $id,
            'CREATED_BY' => $row['CREATED_BY'],
            'SECTION_ID' => $sectionResult->getId(),
            'CREATION_DATE' => $row['CREATION_DATE'],
        ]);

        if (!$result->isSuccess()) {
            var_dump('Not add offer to favorite section '.$sectionResult->getId());
            continue;
        }
    }

    var_dump('Favorite section succes add');
    var_dump('|--------|');
}