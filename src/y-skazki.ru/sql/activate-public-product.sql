-- Активирует все товары публичного каталога которые активны в каталоге 1C но не активны в публичном каталоге

SET @LINK_PROPERTY_ID=1446, @PUBLIC_CATALOG_ID=60, @EXTERNAL_CATALOG_ID=68;
CREATE TEMPORARY TABLE IF NOT EXISTS `temp_activate_id` AS (
    SELECT
        `public`.`ID` AS `ID`
    FROM `b_iblock_element` `external`
    INNER JOIN (
        SELECT *
        FROM`b_iblock_element_property`
        WHERE `IBLOCK_PROPERTY_ID`=@LINK_PROPERTY_ID
    ) `link` ON `external`.`XML_ID`=`link`.`VALUE`
    INNER JOIN (
        SELECT *
        FROM `b_iblock_element`
        WHERE `IBLOCK_ID`=@PUBLIC_CATALOG_ID
    ) `public` ON `public`.`ID`=`link`.`IBLOCK_ELEMENT_ID`
    WHERE
        `external`.`IBLOCK_ID`=@EXTERNAL_CATALOG_ID
        AND `external`.`ACTIVE`='Y'
        AND `public`.`ACTIVE`!='Y'
);

UPDATE `b_iblock_element`
SET `ACTIVE`='Y'
WHERE `ID` IN (SELECT `ID` FROM `temp_activate_id`)
