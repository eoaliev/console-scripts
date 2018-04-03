-- Деактивирует все активные товары которые есть в публичном каталоге но которых нет либо они не активны в каталоге 1С

SET @LINK_PROPERTY_ID=1446, @PUBLIC_CATALOG_ID=60, @EXTERNAL_CATALOG_ID=68;
CREATE TEMPORARY TABLE IF NOT EXISTS `temp_deactivate_id` AS (
    SELECT
        `public`.`ID` AS `ID`
    FROM `b_iblock_element` `public`
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
    WHERE
        `public`.`IBLOCK_ID`=@PUBLIC_CATALOG_ID
        AND `public`.`ACTIVE`='Y'
        AND (
            `link`.`ID` IS NULL
            OR `external`.`ID` IS NULL
            OR `external`.`ACTIVE`!='Y'
        )
);

UPDATE `b_iblock_element`
SET `ACTIVE`='N'
WHERE `ID` IN (SELECT `ID` FROM `temp_deactivate_id`)
