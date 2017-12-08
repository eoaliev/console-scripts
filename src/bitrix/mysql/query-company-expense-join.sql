SELECT
    `c`.`ID` AS `ID`,
    (
        SELECT SUM(DISTINCT `p`.`AMOUNT`)
        FROM `bizprofi_marsys_promotion_channel_payment_log` `p`
        INNER JOIN `b_mp_company_binding` `cb` ON `cb`.`CHANNEL_ID`=`p`.`CHANNEL_ID` OR `cb`.`PROJECT_ID`=`p`.`PROJECT_ID`
        WHERE
            `cb`.`COMPANY_ID`=`c`.`ID`
    ) /
    (
        SELECT COUNT(DISTINCT `cb`.`COMPANY_ID`)
        FROM `b_mp_company_binding` `cb`
        INNER JOIN `b_mp_company_binding` `cbn` ON `cbn`.`CHANNEL_ID`=`cb`.`CHANNEL_ID` OR `cbn`.`PROJECT_ID`=`cb`.`PROJECT_ID`
        WHERE
            `cbn`.`COMPANY_ID`=`c`.`ID`
    ) AS `EXPENSE`
FROM `b_crm_company` `c`
WHERE (
        SELECT SUM(DISTINCT `p`.`AMOUNT`)
        FROM `bizprofi_marsys_promotion_channel_payment_log` `p`
        INNER JOIN `b_mp_company_binding` `cb` ON `cb`.`CHANNEL_ID`=`p`.`CHANNEL_ID` OR `cb`.`PROJECT_ID`=`p`.`PROJECT_ID`
        WHERE
            `cb`.`COMPANY_ID`=`c`.`ID`
    ) /
    (
        SELECT COUNT(DISTINCT `cb`.`COMPANY_ID`)
        FROM `b_mp_company_binding` `cb`
        INNER JOIN `b_mp_company_binding` `cbn` ON `cbn`.`CHANNEL_ID`=`cb`.`CHANNEL_ID` OR `cbn`.`PROJECT_ID`=`cb`.`PROJECT_ID`
        WHERE
            `cbn`.`COMPANY_ID`=`c`.`ID`
    ) > 0
