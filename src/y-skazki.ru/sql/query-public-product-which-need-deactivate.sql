-- Выбирает все активные товары которые есть в публичном каталоге но которых нет либо они не активны в каталоге 1С

SET @LINK_PROPERTY_ID=1446, @PUBLIC_CATALOG_ID=60, @EXTERNAL_CATALOG_ID=68;
SELECT
    `link`.`VALUE` AS `1C_ID`,
    `public`.`ID` AS `BITRIX_ID`,
    `public`.`NAME` AS `NAME`,
    (
        SELECT GROUP_CONCAT(DISTINCT `section`.`NAME` ORDER BY `section`.`DEPTH_LEVEL` ASC SEPARATOR ' / ')
        FROM `b_iblock_section` `section`
        WHERE
            `section`.`IBLOCK_ID`=`category`.`IBLOCK_ID`
            AND `section`.`DEPTH_LEVEL`<`category`.`DEPTH_LEVEL`
            AND `section`.`LEFT_MARGIN`<=`category`.`LEFT_MARGIN`
            AND `section`.`RIGHT_MARGIN`>=`category`.`RIGHT_MARGIN`
    ) AS `CATEGORIES`,
    @SECTION_PATH:=(
        SELECT GROUP_CONCAT(DISTINCT `section`.`CODE` ORDER BY `section`.`DEPTH_LEVEL` ASC SEPARATOR '/')
        FROM `b_iblock_section` `section`
        WHERE
            `section`.`IBLOCK_ID`=`category`.`IBLOCK_ID`
            AND `section`.`DEPTH_LEVEL`<`category`.`DEPTH_LEVEL`
            AND `section`.`LEFT_MARGIN`<=`category`.`LEFT_MARGIN`
            AND `section`.`RIGHT_MARGIN`>=`category`.`RIGHT_MARGIN`
    ) AS `SECTION_PATH`,
    CONCAT(
        'https://y-skazki.ru/catalog/',
        IF(@SECTION_PATH IS NOT NULL, CONCAT(@SECTION_PATH, '/'), ''),
        `public`.`ID`,
        '/'
    ) AS `PUBLIC_LINK`,
    CONCAT('https://y-skazki.ru/bitrix/admin/iblock_element_edit.php?IBLOCK_ID=', `public`.`IBLOCK_ID`, '&type=', `public_iblock`.`IBLOCK_TYPE_ID`, '&ID=', `public`.`ID`, '&lang=ru') AS `EDIT_LINK`
FROM `b_iblock_element` `public`
INNER JOIN `b_iblock` `public_iblock` ON `public_iblock`.`ID`=`public`.`IBLOCK_ID`
LEFT JOIN (
    SELECT *
    FROM`b_iblock_element_property`
    WHERE `IBLOCK_PROPERTY_ID`=@LINK_PROPERTY_ID
) `link` ON `public`.`ID`=`link`.`IBLOCK_ELEMENT_ID`
LEFT JOIN (
    SELECT *
    FROM `b_iblock_element`
    WHERE `IBLOCK_ID`=@EXTERNAL_CATALOG_ID
) `external` ON `external`.`XML_ID`=`link`.`VALUE`
LEFT JOIN `b_iblock_section` `category` ON `category`.`ID`=`public`.`IBLOCK_SECTION_ID` AND `category`.`IBLOCK_ID`=`public`.`IBLOCK_ID`
WHERE
    `public`.`IBLOCK_ID`=@PUBLIC_CATALOG_ID
    AND `public`.`ACTIVE`='Y'
    AND (
        `link`.`ID` IS NULL
        OR `external`.`ID` IS NULL
        OR `external`.`ACTIVE`!='Y'
    )
