-- Выбирает все активные товары которые есть в каталоге 1C но которых нет либо они не активны в публичном каталоге

SET @LINK_PROPERTY_ID=1446, @PUBLIC_CATALOG_ID=60, @EXTERNAL_CATALOG_ID=68;
SELECT
    `external`.`XML_ID` AS `1C_ID`,
    `external`.`ID` AS `BITRIX_ID`,
    `external`.`NAME` AS `NAME`,
    `public`.`ACTIVE` AS `PUBLIC_ACTIVE`,
    `public`.`ID` AS `PUBLIC_ID`,
    `link`.`ID` AS `LINK_ID`,
    (
        SELECT GROUP_CONCAT(DISTINCT `section`.`NAME` ORDER BY `section`.`DEPTH_LEVEL` ASC SEPARATOR ' / ')
        FROM `b_iblock_section` `section`
        WHERE
            `section`.`IBLOCK_ID`=`category`.`IBLOCK_ID`
            AND `section`.`DEPTH_LEVEL`<`category`.`DEPTH_LEVEL`
            AND `section`.`LEFT_MARGIN`<=`category`.`LEFT_MARGIN`
            AND `section`.`RIGHT_MARGIN`>=`category`.`RIGHT_MARGIN`
    ) AS `CATEGORIES`,
    CONCAT('https://y-skazki.ru/bitrix/admin/iblock_element_edit.php?IBLOCK_ID=', `external`.`IBLOCK_ID`, '&type=', `external_iblock`.`IBLOCK_TYPE_ID`, '&ID=', `external`.`ID`, '&lang=ru') AS `EXTERNAL_EDIT_LINK`,
    IF(
        `public`.`ID` IS NOT NULL,
        CONCAT('https://y-skazki.ru/bitrix/admin/iblock_element_edit.php?IBLOCK_ID=', `public`.`IBLOCK_ID`, '&type=', `public_iblock`.`IBLOCK_TYPE_ID`, '&ID=', `public`.`ID`, '&lang=ru'),
        NULL
    ) AS `PUBLIC_EDIT_LINK`
FROM `b_iblock_element` `external`
INNER JOIN `b_iblock` `external_iblock` ON `external_iblock`.`ID`=`external`.`IBLOCK_ID`
LEFT JOIN (
    SELECT *
    FROM`b_iblock_element_property`
    WHERE `IBLOCK_PROPERTY_ID`=@LINK_PROPERTY_ID
) `link` ON `external`.`XML_ID`=`link`.`VALUE`
LEFT JOIN (
    SELECT *
    FROM `b_iblock_element`
    WHERE `IBLOCK_ID`=@PUBLIC_CATALOG_ID
) `public` ON `public`.`ID`=`link`.`IBLOCK_ELEMENT_ID`
LEFT JOIN `b_iblock` `public_iblock` ON `public_iblock`.`ID`=`public`.`IBLOCK_ID`
LEFT JOIN `b_iblock_section` `category` ON `category`.`ID`=`external`.`IBLOCK_SECTION_ID` AND `category`.`IBLOCK_ID`=`external`.`IBLOCK_ID`
WHERE
    `external`.`IBLOCK_ID`=@EXTERNAL_CATALOG_ID
    AND `external`.`ACTIVE`='Y'
    AND (
        `link`.`ID` IS NULL
        OR `public`.`ID` IS NULL
        OR `public`.`ACTIVE`!='Y'
    )
