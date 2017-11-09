<?php
if (Bitrix\Main\Loader::includeModule('iblock')) {
    $obElement = new CIBlockElement;
    $domain = Bitrix\Main\Config\Option::get('realty', 'SCHEME');
    $domain .= Bitrix\Main\Config\Option::get('realty', 'DOMAIN');
    $obPublicpage = Realty\PublicpageTable::getList([
        'order' => ['RATING' => 'DESC'], 
        'filter' => ['!DESCRIPTION' => false, '!LOGO' => false, '!CONTACT_PHONE' => false], 
        'select' => ['DESCRIPTION', 'NAME', 'LOGO', 'CONTACT_PHONE', 'TYPE', 'ID'], 
        'limit' => 20, 
    ]);
    while ($arPublicpage = $obPublicpage->fetch()) {
        $element = [];
        $element['PROPERTY_VALUES'] = [];
        $publicpage = Realty\Publicpage::create($arPublicpage);
        $picture = CFile::makeFileArray($publicpage['LOGO']);

        $element['ACTIVE'] = 'Y';
        $element['IBLOCK_ID'] = 8;
        $element['IBLOCK_SECTION_ID'] = false;
        $element['NAME'] = $publicpage['NAME'];
        $element['PREVIEW_PICTURE'] = $picture;
        $element['PREVIEW_TEXT'] = $publicpage['DESCRIPTION'];
        $element['PROPERTY_VALUES']['PHONE'] = $publicpage['CONTACT_PHONE'];
        $element['PROPERTY_VALUES']['PRICE'] = mt_rand(100000, 999999);
        if (mt_rand(0, 1) === 1) {
            $element['PROPERTY_VALUES']['PRICE_FROM'] = 2;
        }
        $element['PROPERTY_VALUES']['URL'] = $domain.$publicpage->getDetailPageUrl();

        if (!empty($element)) {
            $result = $obElement->add($element);
            var_dump($result, $obElement->LAST_ERROR);
        }
    }
}