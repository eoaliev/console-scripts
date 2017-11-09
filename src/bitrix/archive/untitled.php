<?php
$obOffers = Realty\OfferTable::getList([
    'select' => ['ID'],
    'filter' => [
        '><SHOW_COUNTER' => [300, 1500],
        '!LOCATION_LATITUDE' => false,
        '!LOCATION_LONGITUDE' => false,
        '!LIVING_SPACE_VALUE' => false,
        '!KITCHEN_SPACE_VALUE' => false,
        '>FLOOR' => 0,
        '=STATUS' => 'O',
        '!IMAGE_SET' => false,
        '!LOCATION_LOCALITY' => false,
        '!LOCATION_COUNTRY' => false,
    ],
    'limit' => 80,
]);
while ($offer = $obOffers->fetch()) {
    $offers[] = $offer['ID'];
}

echo count($offers);