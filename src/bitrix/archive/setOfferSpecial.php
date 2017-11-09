<?php
$date = new Bitrix\Main\Type\Datetime();
$specialDate = new Bitrix\Main\Type\Datetime();
$date->add('-1m');
$specialDate->add('10d');
$special = ['VIP_EXPIRE_DATE', 'FAST_EXPIRE_DATE', 'SPECIAL_EXPIRE_DATE', 'HIGHLIGHT_EXPIRE_DATE'];
$arSpecial = ['VIP_EXPIRE_DATE' => [], 'FAST_EXPIRE_DATE' => [], 'SPECIAL_EXPIRE_DATE' => [], 'HIGHLIGHT_EXPIRE_DATE' => []];

$obOffers = Realty\OfferTable::getList([
    'select' => ['ID'],
    'filter' => [
        '>EXPIRE_DATE' => $date,
        '!LOCATION_LATITUDE' => false,
        '!LOCATION_LONGITUDE' => false,
        '!LIVING_SPACE_VALUE' => false,
        '!KITCHEN_SPACE_VALUE' => false,
        '>FLOOR' => 0,
        '=STATUS' => Realty\OfferTable::STATUS_ACTIVE,
        '!IMAGE_SET' => false,
        '!LOCATION_LOCALITY' => false,
        '!LOCATION_COUNTRY' => false,
    ],
    'limit' => 200,
]);
while ($offer = $obOffers->fetch()) {
    $key = mt_rand(0, 3);
    $offers[] = $offer['ID'];
    $offerField = [$special[$key] => $specialDate];
    $result = Realty\OfferTable::update($offer['ID'], $offerField);
    if ($result->isSuccess()) {
        $arSpecial[$special[$key]][] = $offer['ID'];
    }
}

print_r($arSpecial);