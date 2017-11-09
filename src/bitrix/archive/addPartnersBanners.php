<?php
$isLoadIblock = Bitrix\Main\Loader::includeModule('iblock');
$isLoadAdvertising = Bitrix\Main\Loader::includeModule('advertising');
if ($isLoadIblock && $isLoadAdvertising) {
    $obElement = CIBlockElement::getList(
        ['ID' => 'ASC'], 
        ['ACTIVE' => 'Y', 'IBLOCK_ID' => 8], 
        false, 
        false, 
        ['ID', 'NAME']
    );
    $weight = 10;
    while ($element = $obElement->fetch()) {
        $advertising = [];

        $advertising['CODE_TYPE'] = 'html';
        $advertising['AD_TYPE'] = 'html';
        $advertising['arrSITE'] = ['s1'];
        $advertising['CODE'] = '<script src="/api/banners/?ID='.$element['ID'].'"></script>';
        $advertising['CONTRACT_ID'] = 1;
        $advertising['TYPE_SID'] = 'sidebar_partners';
        $advertising['STATUS_SID'] = 'PUBLISHED';
        $advertising['NAME'] = $element['NAME'];
        $advertising['ACTIVE'] = 'Y';
        $advertising['WEIGHT'] = $weight;
        $advertising['arrWEEKDAY'] = [
            "SUNDAY"    => range(0, 23),
            "MONDAY"    => range(0, 23),
            "TUESDAY"   => range(0, 23),
            "WEDNESDAY" => range(0, 23),
            "THURSDAY"  => range(0, 23),
            "FRIDAY"    => range(0, 23),
            "SATURDAY"  => range(0, 23),
        ];

        $publicpage = Realty\PublicpageTable::getRow(['filter' => ['NAME' => $element['NAME']]]);
        if (!empty($publicpage)) {
            $advertising['KEYWORDS'] = [];
            foreach (['LOCATION_COUNTRY', 'LOCATION_REGION', 'LOCATION_LOCALITY'] as $level) {
                if (!empty($publicpage[$level])) {
                    $advertising['KEYWORDS'][] = $publicpage[$level];
                }
            }
        }

        if (is_array($advertising['KEYWORDS']) && !empty($advertising['KEYWORDS'])) {
            $advertising['KEYWORDS'] = implode(PHP_EOL, $advertising['KEYWORDS']);
        }
        
        if (!empty($advertising)) {
            $result = CAdvBanner::Set($advertising);
            var_dump($result);
        }

        $weight += 10;
    }
}