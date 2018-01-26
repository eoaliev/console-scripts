SELECT
    `d`.`ID` AS `ID`,
    `d`.`TITLE` AS `TITLE`,
    `vs`.`PORTAL_NUMBER` AS `PORTAL_NUMBER`,
    `cd`.`CHANNEL_ID` AS `CD_CHANNEL_ID`,
    `cd`.`PROJECT_ID` AS `CD_PROJECT_ID`,
    `uts`.`UF_MARSYS_CHANNEL_ID` AS `UF_MARSYS_CHANNEL_ID`,
    `uts`.`UF_MARSYS_PROJECT_ID` AS `UF_MARSYS_PROJECT_ID`,
    `cp`.`CHANNEL_ID` AS `CP_CHANNEL_ID`,
    `pp`.`PROJECT_ID` AS `PP_PROJECT_ID`,
    `p`.`NAME` AS `P_NAME`,
    `c`.`NAME` AS `C_NAME`
FROM `b_crm_deal` `d`
INNER JOIN `b_voximplant_statistic` `vs` ON `vs`.`CRM_ENTITY_ID`=`d`.`LEAD_ID`
INNER JOIN `b_uts_crm_deal` `uts` ON `uts`.`VALUE_ID`=`d`.`ID`
LEFT JOIN `bizprofi_marsys_promotion_channel_deal` `cd` ON `cd`.`DEAL_ID`=`d`.`ID`
LEFT JOIN `bizprofi_marsys_promotion_channel_phone` `cp` ON `cp`.`PHONE`=`vs`.`PORTAL_NUMBER`
LEFT JOIN `bizprofi_marsys_promotion_project_phone` `pp` ON `pp`.`PHONE`=`vs`.`PORTAL_NUMBER`
LEFT JOIN `bizprofi_marsys_promotion_channel` `c` ON `c`.`ID`=`cp`.`CHANNEL_ID`
LEFT JOIN `bizprofi_marsys_promotion_project` `p` ON `p`.`ID`=`pp`.`PROJECT_ID`
WHERE
    -- `d`.`ID` IN (23724, 23768, 24123, 24310, 24062, 23704, 23742, 23829, 23952, 23966, 24184, 24339, 23677, 24097, 23740, 24029, 24162, 24228, 24258, 23659, 23685, 23699, 23705, 23718, 23721, 23725, 23752, 23759, 23762, 23769, 23789, 23931, 23934, 23939, 23941, 23947, 23954, 23962, 23971, 23976, 23981, 23984, 24006, 24032, 24034, 24037, 24038, 24070, 24099, 24135, 24139, 24147, 24157, 24158, 24161, 24170, 24175, 24188, 24209, 24223, 24235, 24259, 24280, 24283, 24300, 24308, 24313, 24314, 24322, 24323, 24326, 24327, 24330, 24331, 23951, 24336, 23681, 23717, 23975, 23951, 24336)
    (`vs`.`INCOMING` IN (2, 3, 4) AND `vs`.`CRM_ENTITY_TYPE`='LEAD')
    AND (
        (`cd`.`CHANNEL_ID` IS NULL OR `cd`.`CHANNEL_ID` = '')
        OR (`cd`.`PROJECT_ID` IS NULL OR `cd`.`PROJECT_ID` = '')
        OR (`uts`.`UF_MARSYS_CHANNEL_ID` IS NULL OR `uts`.`UF_MARSYS_CHANNEL_ID` = '')
        OR (`uts`.`UF_MARSYS_PROJECT_ID` IS NULL OR `uts`.`UF_MARSYS_PROJECT_ID` = '')
    )
    AND (
        (`cp`.`CHANNEL_ID` IS NOT NULL AND `cp`.`CHANNEL_ID` != '')
        OR (`pp`.`PROJECT_ID` IS NOT NULL AND `pp`.`PROJECT_ID` != '')
    )
    AND (IFNULL(`cd`.`CHANNEL_ID`, 0) != `cp`.`CHANNEL_ID` OR IFNULL(`cd`.`PROJECT_ID`, 0) != `pp`.`PROJECT_ID`)
-- GROUP BY `vs`.`PORTAL_NUMBER`
