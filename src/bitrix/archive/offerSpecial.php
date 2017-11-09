<?php
$expire = new Bitrix\Main\Type\Datetime();
$expire->add('7d');

$offer = [
    ['SPECIAL_EXPIRE_DATE', 1770108], 
    ['SPECIAL_EXPIRE_DATE', 1769327], 
    ['HIGHLIGHT_EXPIRE_DATE', 1769235], 
    ['HIGHLIGHT_EXPIRE_DATE', 1769226], 
    ['VIP_EXPIRE_DATE', 1768955], 
    ['VIP_EXPIRE_DATE', 1769287], 
    ['FAST_EXPIRE_DATE', 1769271], 
    ['FAST_EXPIRE_DATE', 1769267]
];

foreach ($offer as $item) {
    $result = Realty\OfferTable::update($item[1], [$item[0] => $expire]);
    var_dump($result->isSuccess());
}
