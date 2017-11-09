SELECT
    `d`.`ID` as `DEAL_ID`,
    `uf`.`UF_MARSYS_CHANNEL_ID` as `UF_CHANNEL_ID`,
    `cd`.`CHANNEL_ID` as `CHANNEL_ID`,
    `uf`.`UF_MARSYS_PROJECT_ID` as `UF_PROJECT_ID`,
    `cd`.`PROJECT_ID` as `PROJECT_ID`,
    `vs`.`PORTAL_NUMBER` as `PORTAL_NUMBER`,
    `md`.`TARGET` as `TARGET`,
    `m`.`UTM` as `UTM`,
    `m`.`REFERRER` as `REFERRER`
FROM `b_crm_deal` `d`
LEFT JOIN `b_uts_crm_deal` `uf` ON `uf`.`VALUE_ID`=`d`.`ID`
LEFT JOIN `bizprofi_marsys_promotion_channel_deal` `cd` ON `cd`.`DEAL_ID`=`d`.`ID`
LEFT JOIN `b_voximplant_statistic` `vs` ON `vs`.`CRM_ENTITY_ID`=`d`.`LEAD_ID` AND `vs`.`CRM_ENTITY_TYPE`='LEAD'
LEFT JOIN `bizprofi_marsys_promotion_metric_deal` `md` ON `md`.`DEAL_ID`=`d`.`ID`
LEFT JOIN `bizprofi_marsys_promotion_metric` `m` ON `m`.`ID`=`md`.`METRIC_ID`
WHERE 
    `d`.`DATE_CREATE`>'2017-09-26 00:00:00' AND
    (
        (`uf`.`UF_MARSYS_CHANNEL_ID` IS NOT NULL OR `uf`.`UF_MARSYS_CHANNEL_ID`!='') OR
        (`cd`.`ID` IS NOT NULL OR `cd`.`ID`!='')
    ) AND
    (
        `m`.`ID` IS NOT NULL AND 
        `m`.`UTM` IS NOT NULL
    )
GROUP BY `d`.`ID`
ORDER BY `d`.`ID` ASC