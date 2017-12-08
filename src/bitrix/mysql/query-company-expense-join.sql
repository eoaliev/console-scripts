SELECT
    `c`.`ID` AS `ID`,
    (
        SELECT SUM(`p`.`AMOUNT`)
        FROM `bizprofi_marsys_promotion_channel_payment_log` `p`
        WHERE
            `p`.`CHANNEL_ID` IN (
                SELECT `cb`.`CHANNEL_ID`
                FROM `b_mp_company_binding` `cb`
                WHERE `cb`.`COMPANY_ID`=`c`.`ID`
            )
            OR `p`.`PROJECT_ID` IN (
                SELECT `cb`.`PROJECT_ID`
                FROM `b_mp_company_binding` `cb`
                WHERE `cb`.`COMPANY_ID`=`c`.`ID`
            )
    ) /
    (
        SELECT COUNT(DISTINCT `cb`.`COMPANY_ID`)
        FROM `b_mp_company_binding` `cb`
        WHERE
            `cb`.`CHANNEL_ID` IN (
                SELECT `cbn`.`CHANNEL_ID`
                FROM `b_mp_company_binding` `cbn`
                WHERE `cbn`.`COMPANY_ID`=`c`.`ID`
            )
            OR `cb`.`PROJECT_ID` IN (
                SELECT `cbn`.`PROJECT_ID`
                FROM `b_mp_company_binding` `cbn`
                WHERE `cbn`.`COMPANY_ID`=`c`.`ID`
            )
    ) AS `EXPENSE`
FROM `b_crm_company` `c`
WHERE `c`.`ID`=1058 AND (
        SELECT SUM(`p`.`AMOUNT`)
        FROM `bizprofi_marsys_promotion_channel_payment_log` `p`
        WHERE
            `p`.`CHANNEL_ID` IN (
                SELECT `cb`.`CHANNEL_ID`
                FROM `b_mp_company_binding` `cb`
                WHERE `cb`.`COMPANY_ID`=`c`.`ID`
            )
            AND `p`.`PROJECT_ID` IN (
                SELECT `cb`.`PROJECT_ID`
                FROM `b_mp_company_binding` `cb`
                WHERE `cb`.`COMPANY_ID`=`c`.`ID`
            )
    ) -
    (
        SELECT COUNT(DISTINCT `cb`.`COMPANY_ID`)
        FROM `b_mp_company_binding` `cb`
        WHERE
            `cb`.`CHANNEL_ID` IN (
                SELECT `cbn`.`CHANNEL_ID`
                FROM `b_mp_company_binding` `cbn`
                WHERE `cbn`.`COMPANY_ID`=`c`.`ID`
            )
            OR `cb`.`PROJECT_ID` IN (
                SELECT `cbn`.`PROJECT_ID`
                FROM `b_mp_company_binding` `cbn`
                WHERE `cbn`.`COMPANY_ID`=`c`.`ID`
            )
    ) > 0
