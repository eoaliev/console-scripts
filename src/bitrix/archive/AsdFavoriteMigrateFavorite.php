<?php

use Bitrix\Main\Loader;
use Realty\DataManager\FavoriteOfferTable;
use Realty\DataManager\FavoriteArticleTable;
use Realty\DataManager\OfferTable;
use Realty\DataManager\UserTable;
use Realty\DataManager\ArticleTable;

Loader::includeModule('asd.favorite');

$rows = \CASDfavorite::getLikes();
while ($row = $rows->fetch()) {
    if (!in_array($row['CODE'], ['blogs', 'objects'], true)) {
        var_dump('type not offer or article');
        continue;
    }

    $user = UserTable::getRowById($row['USER_ID']);
    if (empty($user)) {
        var_dump('user '.$row['USER_ID'].' not found');
        continue;
    }

    if ($row['CODE'] === 'objects') {
        $offer = OfferTable::getRowById($row['ELEMENT_ID']);
        if (empty($offer)) {
            var_dump('offer '.$row['ELEMENT_ID'].' not found');
            continue;
        }

        if ($offer['STATUS'] !== OfferTable::STATUS_ACTIVE) {
            var_dump('offer '.$row['ELEMENT_ID'].' not active');
            continue;
        }

        $result = FavoriteOfferTable::add([
            'OFFER_ID' => $row['ELEMENT_ID'],
            'SECTION_ID' => false,
            'CREATED_BY' => $row['USER_ID'],
        ]);
    } elseif ($row['CODE'] === 'blogs') {
        $article = ArticleTable::getRowById($row['ELEMENT_ID']);
        if (empty($article)) {
            var_dump('article '.$row['ELEMENT_ID'].' not found');
            continue;
        }

        if ($article['ACTIVE'] !== 'Y') {
            var_dump('article '.$row['ELEMENT_ID'].' not active');
            continue;
        }

        $result = FavoriteArticleTable::add([
            'ARTICLE_ID' => $row['ELEMENT_ID'],
            'SECTION_ID' => false,
            'CREATED_BY' => $row['USER_ID'],
        ]);
    }

    if (!$result->isSuccess()) {
        var_dump('favorite add error');
        continue;
    }

    var_dump('favorite add success');
    var_dump('|--------|');
}