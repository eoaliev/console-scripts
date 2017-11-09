-- In Sale
-- Query order id where empty catalog or product xml id
SELECT `ORDER_ID`
FROM `b_sale_basket`
WHERE
    (`ORDER_ID` IS NOT NULL OR LENGTH(`ORDER_ID`) > 0)
    AND (
        (`CATALOG_XML_ID` IS NULL OR LENGTH(`CATALOG_XML_ID`) < 0)
        OR (`PRODUCT_XML_ID` IS NULL OR LENGTH(`PRODUCT_XML_ID`) < 0)
    )
GROUP BY `ORDER_ID`
ORDER BY `ORDER_ID` ASC

-- In Bitrix24
-- ORIGIN_ID implode preview query result
-- Query order id where deal not change to manager
SELECT `ORIGIN_ID`
FROM `b_crm_deal`
WHERE
    `STAGE_ID` = 'NEW'
    AND `ORIGINATOR_ID` = 1
    AND `ORIGIN_ID` IN (24, 67, 81, 82, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 153, 158, 159, 160, 197, 198, 199, 200, 201, 202, 204, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 275, 276, 277, 278, 279, 280, 281, 282, 288, 291, 438, 440, 456, 1291, 1292, 1325, 1331, 1340, 1359, 1370, 1373, 1382, 1396, 1423, 1438, 1444, 1445, 1446, 1448, 1450, 1451, 1458, 1463, 1466, 1474, 1532, 1534, 1535, 1540, 1544, 1552, 1554, 1556, 1564, 1569, 1579, 1580, 1581, 1582, 1583, 1594, 1596, 1600, 1601, 1606, 1607, 1610, 1619, 1620, 1621, 1649, 1657, 1668, 1679, 1682, 1686, 1691, 1694, 1697, 1700, 1702, 1707, 1709, 1715, 1718, 1730, 1735, 1736, 1738, 1752, 1753, 1757, 1763, 1768, 1777, 1782, 1784, 1787)
GROUP BY `ORIGIN_ID`
ORDER BY `ORIGIN_ID`

-- In Sale
-- ORDER_ID implode preview query result
-- Query catalog or product xml id to orders not change manager
SELECT
    IFNULL(`sale_basket`.`CATALOG_XML_ID`, `offer_iblock`.`XML_ID`) AS `CATALOG_XML_ID`,
    IFNULL(`sale_basket`.`PRODUCT_XML_ID`, CONCAT(IFNULL(`product`.`XML_ID`, ''), IF(`product`.`XML_ID`, '#', ''), `offer`.`XML_ID`)) AS `PRODUCT_XML_ID`,
    `order`.`DATE_UPDATE` AS `LAST_UPDATE_TIME`
FROM `b_sale_basket` `sale_basket`
INNER JOIN `b_sale_order` `order` ON `order`.`ID`=`sale_basket`.`ORDER_ID`
INNER JOIN `b_iblock_element` `offer` ON `offer`.`ID`=`sale_basket`.`PRODUCT_ID`
INNER JOIN `b_iblock` `offer_iblock` ON `offer_iblock`.`ID`=`offer`.`IBLOCK_ID`
LEFT JOIN `b_iblock_property` `cml2_link` ON `cml2_link`.`IBLOCK_ID`=`offer_iblock`.`ID` AND `cml2_link`.`CODE`='CML2_LINK'
LEFT JOIN `b_iblock_element_property` `cml2_link_value` ON `cml2_link_value`.`IBLOCK_PROPERTY_ID`=`cml2_link`.`ID` AND `cml2_link_value`.`IBLOCK_ELEMENT_ID`=`offer`.`ID`
LEFT JOIN `b_iblock_element` `product` ON `product`.`ID`=`cml2_link_value`.`VALUE`
WHERE
    `ORDER_ID` IN (1331, 1373, 1423, 1438)

-- In Sale
-- ORDER_ID implode preview query result
-- Set catalog or product xml id to orders not change manager
UPDATE `b_sale_basket` `sale_basket`
INNER JOIN `b_sale_order` `order` ON `order`.`ID`=`sale_basket`.`ORDER_ID`
INNER JOIN `b_iblock_element` `offer` ON `offer`.`ID`=`sale_basket`.`PRODUCT_ID`
INNER JOIN `b_iblock` `offer_iblock` ON `offer_iblock`.`ID`=`offer`.`IBLOCK_ID`
LEFT JOIN `b_iblock_property` `cml2_link` ON `cml2_link`.`IBLOCK_ID`=`offer_iblock`.`ID` AND `cml2_link`.`CODE`='CML2_LINK'
LEFT JOIN `b_iblock_element_property` `cml2_link_value` ON `cml2_link_value`.`IBLOCK_PROPERTY_ID`=`cml2_link`.`ID` AND `cml2_link_value`.`IBLOCK_ELEMENT_ID`=`offer`.`ID`
LEFT JOIN `b_iblock_element` `product` ON `product`.`ID`=`cml2_link_value`.`VALUE`
SET
    `sale_basket`.`CATALOG_XML_ID` = IFNULL(`sale_basket`.`CATALOG_XML_ID`, `offer_iblock`.`XML_ID`),
    `sale_basket`.`PRODUCT_XML_ID` = IFNULL(`sale_basket`.`PRODUCT_XML_ID`, CONCAT(IFNULL(`product`.`XML_ID`, ''), IF(`product`.`XML_ID`, '#', ''), `offer`.`XML_ID`)),
    `order`.`DATE_UPDATE` = NOW()
WHERE
    `ORDER_ID` IN (1331, 1373, 1423, 1438)
