SELECT
    IFNULL(`e`.`XML_ID`, `e`.`ID`) AS `IE_XML_ID`,
    `e`.`NAME` AS `IE_NAME`,
    `e`.`ACTIVE` AS `IE_ACTIVE`,
    `ep`.`VALUE` AS `IP_PROP457`
FROM `b_iblock_element` `e`
LEFT JOIN `b_iblock_element_property` `ep` ON `ep`.`IBLOCK_ELEMENT_ID`=`e`.`ID` AND `ep`.`IBLOCK_PROPERTY_ID`=457
WHERE
    `e`.`IBLOCK_ID`=9
    AND `e`.`ACTIVE`='Y'
    AND (`ep`.`VALUE` IS NULL OR LENGTH(`ep`.`VALUE`) <= 0);


SELECT
    IFNULL(`e`.`XML_ID`, `e`.`ID`) AS `IE_XML_ID`,
    `e`.`NAME` AS `IE_NAME`,
    `e`.`ACTIVE` AS `IE_ACTIVE`,
    `ep`.`VALUE` AS `IP_PROP457`
FROM `b_iblock_element` `e`
LEFT JOIN `b_iblock_element_property` `ep` ON `ep`.`IBLOCK_ELEMENT_ID`=`e`.`ID` AND `ep`.`IBLOCK_PROPERTY_ID`=458
WHERE
    `e`.`IBLOCK_ID`=10
    AND `e`.`ACTIVE`='Y'
    AND (`ep`.`VALUE` IS NULL OR LENGTH(`ep`.`VALUE`) <= 0);
