SELECT
    `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID` AS `ID`,
    `bizprofi_marsyspromotion_datamanager_promotion_channel`.`DEPTH` AS `DEPTH`,
    `bizprofi_marsyspromotion_datamanager_promotion_channel`.`TREE_PATH` AS `TREE_PATH`,
    `bizprofi_marsyspromotion_datamanager_promotion_channel`.`PARENT` AS `PARENT`,
    `bizprofi_marsyspromotion_datamanager_promotion_channel`.`NAME` AS `NAME`,
    `bizprofi_marsyspromotion_datamanager_promotion_channel`.`CODE` AS `CODE`,
    `bizprofi_marsyspromotion_datamanager_promotion_channel`.`DEFAULT` AS `DEFAULT`,
    `bizprofi_marsyspromotion_datamanager_promotion_channel`.`SORT` AS `SORT`,
    @INTERACTION:=(SELECT
    COUNT(1) AS `INTERACTION`
FROM `b_crm_deal` `crm_deal`
INNER JOIN `bizprofi_marsys_promotion_channel_deal` `crm_deal_channel_deal` ON `crm_deal_channel_deal`.`DEAL_ID` = `crm_deal`.`ID`
INNER JOIN `bizprofi_marsys_promotion_channel` `crm_deal_channel_deal_channel` ON `crm_deal_channel_deal`.`CHANNEL_ID` = `crm_deal_channel_deal_channel`.`ID`
WHERE `crm_deal`.`TYPE_ID` = 'SALE'
AND (
    (
        `crm_deal_channel_deal`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`
    )
    OR (
        UPPER(`crm_deal_channel_deal_channel`.`TREE_PATH`) like CONCAT("%.", `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, ".%") ESCAPE '!'
    )
)) AS `__INTERACTION`,
    @SELLING:=(SELECT
    COUNT(1) AS `SELLING`
FROM `b_crm_deal` `crm_deal`
INNER JOIN `bizprofi_marsys_promotion_channel_deal` `crm_deal_channel_deal` ON `crm_deal_channel_deal`.`DEAL_ID` = `crm_deal`.`ID`
INNER JOIN `bizprofi_marsys_promotion_channel` `crm_deal_channel_deal_channel` ON `crm_deal_channel_deal`.`CHANNEL_ID` = `crm_deal_channel_deal_channel`.`ID`
WHERE `crm_deal`.`TYPE_ID` = 'SALE'
AND `crm_deal`.`STAGE_ID` = 'WON'
AND (
    (
        `crm_deal_channel_deal`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`
    )
    OR (
        UPPER(`crm_deal_channel_deal_channel`.`TREE_PATH`) like CONCAT("%.", `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, ".%") ESCAPE '!'
    )
)) AS `__SELLING`,
    @INCOME:=(SELECT
    SUM(`crm_deal`.`OPPORTUNITY`) AS `INCOME`
FROM `b_crm_deal` `crm_deal`
INNER JOIN `bizprofi_marsys_promotion_channel_deal` `crm_deal_channel_deal` ON `crm_deal_channel_deal`.`DEAL_ID` = `crm_deal`.`ID`
INNER JOIN `bizprofi_marsys_promotion_channel` `crm_deal_channel_deal_channel` ON `crm_deal_channel_deal`.`CHANNEL_ID` = `crm_deal_channel_deal_channel`.`ID`
WHERE `crm_deal`.`TYPE_ID` = 'SALE'
AND `crm_deal`.`STAGE_ID` = 'WON'
AND (
    (
        `crm_deal_channel_deal`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`
    )
    OR (
        UPPER(`crm_deal_channel_deal_channel`.`TREE_PATH`) like CONCAT("%.", `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, ".%") ESCAPE '!'
    )
)) AS `__INCOME`,
    @LT_INCOME:=(SELECT
    SUM(`crm_deal`.`OPPORTUNITY`) AS `INCOME`
FROM `b_crm_deal` `crm_deal`
INNER JOIN `bizprofi_marsys_promotion_channel_deal` `crm_deal_channel_deal` ON `crm_deal_channel_deal`.`DEAL_ID` = `crm_deal`.`ID`
INNER JOIN `bizprofi_marsys_promotion_channel` `crm_deal_channel_deal_channel` ON `crm_deal_channel_deal`.`CHANNEL_ID` = `crm_deal_channel_deal_channel`.`ID`
WHERE `crm_deal`.`TYPE_ID` = 'SALE'
AND `crm_deal`.`STAGE_ID` = 'WON'
AND (
    (
        `crm_deal_channel_deal`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`
    )
    OR (
        UPPER(`crm_deal_channel_deal_channel`.`TREE_PATH`) like CONCAT("%.", `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, ".%") ESCAPE '!'
    )
)) AS `__LT_INCOME`,
    @EXPENSE:=(SELECT
    SUM(`bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`AMOUNT`) AS `EXPENSE`
FROM `bizprofi_marsys_promotion_channel_payment_log` `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`
INNER JOIN `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_channel` ON `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_channel`.`ID`
WHERE (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`
    )
    OR (
        UPPER(`bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_channel`.`TREE_PATH`) like CONCAT("%.", `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, ".%") ESCAPE '!'
    )
)) AS `__EXPENSE`,
    @LT_EXPENSE:=(SELECT
    SUM(`bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`AMOUNT`) AS `EXPENSE`
FROM `bizprofi_marsys_promotion_channel_payment_log` `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`
INNER JOIN `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_channel` ON `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_channel`.`ID`
WHERE (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`
    )
    OR (
        UPPER(`bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_channel`.`TREE_PATH`) like CONCAT("%.", `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, ".%") ESCAPE '!'
    )
)) AS `__LT_EXPENSE`,
    @CLIENT:=(SELECT
    COUNT(DISTINCT(`bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`COMPANY_ID`)) AS `CLIENT`
FROM `b_mp_company_binding` `bizprofi_marsyspromotion_datamanager_promotion_company_binding`
LEFT JOIN `bizprofi_marsys_promotion_metric_deal` `bizprofi_marsyspromotion_datamanager_promotion_company_binding_metric_deal` ON `bizprofi_marsyspromotion_datamanager_promotion_company_binding_metric_deal`.`METRIC_ID` = `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`ENTITY_ID`
AND `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`ENTITY_TYPE` = 'M'
LEFT JOIN `b_crm_deal` `bizprofi_marsyspromotion_datamanager_promotion_company_binding_deal` ON (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_company_binding_deal`.`ID` = `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`ENTITY_ID`
        AND `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`ENTITY_TYPE` = 'D'
    )
    OR (
        `bizprofi_marsyspromotion_datamanager_promotion_company_binding_deal`.`ID` = `bizprofi_marsyspromotion_datamanager_promotion_company_binding_metric_deal`.`DEAL_ID`
    )
)
INNER JOIN `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_company_binding_channel` ON `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_company_binding_channel`.`ID`
WHERE `bizprofi_marsyspromotion_datamanager_promotion_company_binding_deal`.`TYPE_ID` = 'SALE'
AND `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`COMPANY_ID` > '0'
AND (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`
    )
    OR (
        UPPER(`bizprofi_marsyspromotion_datamanager_promotion_company_binding_channel`.`TREE_PATH`) like CONCAT("%.", `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, ".%") ESCAPE '!'
    )
)) AS `__CLIENT`,
    @DEVICE_MOBILE_COUNT:=(SELECT
    COUNT(DISTINCT 1) AS `METRIC_COUNT`
FROM `bizprofi_marsys_promotion_metric_deal` `bizprofi_marsyspromotion_datamanager_promotion_metric_deal`
INNER JOIN `bizprofi_marsys_promotion_channel_deal` `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal`.`DEAL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_deal`.`DEAL_ID`
INNER JOIN `b_crm_deal` `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_deal` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_deal`.`DEAL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_deal`.`ID`
INNER JOIN `bizprofi_marsys_promotion_metric` `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_metric` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_deal`.`METRIC_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_metric`.`ID`
INNER JOIN `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal_channel` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal_channel`.`ID`
WHERE `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_deal`.`TYPE_ID` = 'SALE'
AND `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_metric`.`DEVICE` in ('mobile', 'мобильный телефон')
AND (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`
    )
    OR (
        UPPER(`bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal_channel`.`TREE_PATH`) like CONCAT("%.", `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, ".%") ESCAPE '!'
    )
)) AS `__DEVICE_MOBILE_COUNT`,
    @DEVICE_TABLET_COUNT:=(SELECT
    COUNT(DISTINCT 1) AS `METRIC_COUNT`
FROM `bizprofi_marsys_promotion_metric_deal` `bizprofi_marsyspromotion_datamanager_promotion_metric_deal`
INNER JOIN `bizprofi_marsys_promotion_channel_deal` `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal`.`DEAL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_deal`.`DEAL_ID`
INNER JOIN `b_crm_deal` `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_deal` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_deal`.`DEAL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_deal`.`ID`
INNER JOIN `bizprofi_marsys_promotion_metric` `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_metric` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_deal`.`METRIC_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_metric`.`ID`
INNER JOIN `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal_channel` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal_channel`.`ID`
WHERE `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_deal`.`TYPE_ID` = 'SALE'
AND `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_metric`.`DEVICE` = 'tablet'
AND (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`
    )
    OR (
        UPPER(`bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal_channel`.`TREE_PATH`) like CONCAT("%.", `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, ".%") ESCAPE '!'
    )
)) AS `__DEVICE_TABLET_COUNT`,
    @DEVICE_TV_COUNT:=(SELECT
    COUNT(DISTINCT 1) AS `METRIC_COUNT`
FROM `bizprofi_marsys_promotion_metric_deal` `bizprofi_marsyspromotion_datamanager_promotion_metric_deal`
INNER JOIN `bizprofi_marsys_promotion_channel_deal` `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal`.`DEAL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_deal`.`DEAL_ID`
INNER JOIN `b_crm_deal` `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_deal` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_deal`.`DEAL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_deal`.`ID`
INNER JOIN `bizprofi_marsys_promotion_metric` `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_metric` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_deal`.`METRIC_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_metric`.`ID`
INNER JOIN `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal_channel` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal_channel`.`ID`
WHERE `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_deal`.`TYPE_ID` = 'SALE'
AND `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_metric`.`DEVICE` = 'tv'
AND (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`
    )
    OR (
        UPPER(`bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal_channel`.`TREE_PATH`) like CONCAT("%.", `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, ".%") ESCAPE '!'
    )
)) AS `__DEVICE_TV_COUNT`,
    @DEVICE_DESKTOP_COUNT:=(SELECT
    COUNT(DISTINCT 1) AS `METRIC_COUNT`
FROM `bizprofi_marsys_promotion_metric_deal` `bizprofi_marsyspromotion_datamanager_promotion_metric_deal`
INNER JOIN `bizprofi_marsys_promotion_channel_deal` `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal`.`DEAL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_deal`.`DEAL_ID`
INNER JOIN `b_crm_deal` `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_deal` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_deal`.`DEAL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_deal`.`ID`
INNER JOIN `bizprofi_marsys_promotion_metric` `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_metric` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_deal`.`METRIC_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_metric`.`ID`
INNER JOIN `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal_channel` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal_channel`.`ID`
WHERE `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_deal`.`TYPE_ID` = 'SALE'
AND `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_metric`.`DEVICE` = 'desktop'
AND (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`
    )
    OR (
        UPPER(`bizprofi_marsyspromotion_datamanager_promotion_metric_deal_channel_deal_channel`.`TREE_PATH`) like CONCAT("%.", `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, ".%") ESCAPE '!'
    )
)) AS `__DEVICE_DESKTOP_COUNT`,
    @INTERACTION AS `INTERACTION`,
    @SELLING AS `SELLING`,
    @INCOME AS `INCOME`,
    @LT_INCOME AS `LT_INCOME`,
    @EXPENSE AS `EXPENSE`,
    @LT_EXPENSE AS `LT_EXPENSE`,
    @CLIENT AS `CLIENT`,
    @DEVICE_MOBILE_COUNT AS `DEVICE_MOBILE_COUNT`,
    @DEVICE_TABLET_COUNT AS `DEVICE_TABLET_COUNT`,
    @DEVICE_TV_COUNT AS `DEVICE_TV_COUNT`,
    @DEVICE_DESKTOP_COUNT AS `DEVICE_DESKTOP_COUNT`,
    IF(@INCOME > 0, @INCOME - @EXPENSE, 0) AS `PROFIT`,
    IF(@LT_INCOME > 0, @LT_INCOME - @LT_EXPENSE, 0) AS `LTV`,
    IF(@EXPENSE > 0, ROUND((IF(@INCOME > 0, @INCOME - @EXPENSE, 0) - @EXPENSE) / @EXPENSE * 100), 0) AS `ROI`,
    IF(@LT_EXPENSE > 0, ROUND((IF(@LT_INCOME > 0, @LT_INCOME - @LT_EXPENSE, 0) - @LT_EXPENSE) / @LT_EXPENSE * 100), 0) AS `LT_ROI`,
    IF(@INTERACTION > 0, ROUND(@EXPENSE / @INTERACTION), 0) AS `INTERACTION_EXPENSE`,
    IF(@SELLING > 0, ROUND(@EXPENSE / @SELLING), 0) AS `SELLING_EXPENSE`,
    IF(@INTERACTION > 0, ROUND(@SELLING / @INTERACTION * 100), 0) AS `SELLING_CONVERSION`,
    IF(@CLIENT > 0, ROUND(@EXPENSE / @CLIENT), 0) AS `CLIENT_EXPENSE`,
    IF(@INTERACTION > 0, ROUND(@CLIENT / @INTERACTION * 100), 0) AS `CLIENT_CONVERSION`,
    IF(@INTERACTION > 0, ROUND(@DEVICE_MOBILE_COUNT / @INTERACTION * 100, 2), 0) AS `DEVICE_MOBILE`,
    IF(@INTERACTION > 0, ROUND(@DEVICE_TABLET_COUNT / @INTERACTION * 100, 2), 0) AS `DEVICE_TABLET`,
    IF(@INTERACTION > 0, ROUND(@DEVICE_TV_COUNT / @INTERACTION * 100, 2), 0) AS `DEVICE_TV`,
    IF(@INTERACTION > 0, ROUND(@DEVICE_DESKTOP_COUNT / @INTERACTION * 100, 2), 0) AS `DEVICE_DESKTOP`,
    (100 - (IF(@INTERACTION > 0, ROUND(@DEVICE_MOBILE_COUNT / @INTERACTION * 100, 2), 0) + IF(@INTERACTION > 0, ROUND(@DEVICE_TABLET_COUNT / @INTERACTION * 100, 2), 0) + IF(@INTERACTION > 0, ROUND(@DEVICE_TV_COUNT / @INTERACTION * 100, 2), 0) + IF(@INTERACTION > 0, ROUND(@DEVICE_DESKTOP_COUNT / @INTERACTION * 100, 2), 0))) AS `DEVICE_OTHER`,
    ((IFNULL((SELECT
    COUNT(1) AS `INTERACTION`
FROM `b_crm_deal` `crm_deal`
INNER JOIN `bizprofi_marsys_promotion_channel_deal` `crm_deal_channel_deal` ON `crm_deal_channel_deal`.`DEAL_ID` = `crm_deal`.`ID`
INNER JOIN `bizprofi_marsys_promotion_channel` `crm_deal_channel_deal_channel` ON `crm_deal_channel_deal`.`CHANNEL_ID` = `crm_deal_channel_deal_channel`.`ID`
WHERE `crm_deal`.`TYPE_ID` = 'SALE'
AND (
    (
        `crm_deal_channel_deal`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`
    )
    OR (
        UPPER(`crm_deal_channel_deal_channel`.`TREE_PATH`) like CONCAT("%.", `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, ".%") ESCAPE '!'
    )
)), 0) + IFNULL((SELECT
    SUM(`bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`AMOUNT`) AS `EXPENSE`
FROM `bizprofi_marsys_promotion_channel_payment_log` `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`
INNER JOIN `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_channel` ON `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_channel`.`ID`
WHERE (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`
    )
    OR (
        UPPER(`bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_channel`.`TREE_PATH`) like CONCAT("%.", `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, ".%") ESCAPE '!'
    )
)), 0)) <= 0) AS `IS_EMPTY`
FROM `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_channel`

WHERE (`bizprofi_marsyspromotion_datamanager_promotion_channel`.`DEPTH` IS NULL OR `bizprofi_marsyspromotion_datamanager_promotion_channel`.`DEPTH` = '')
AND (((IFNULL((SELECT
    COUNT(1) AS `INTERACTION`
FROM `b_crm_deal` `crm_deal`
INNER JOIN `bizprofi_marsys_promotion_channel_deal` `crm_deal_channel_deal` ON `crm_deal_channel_deal`.`DEAL_ID` = `crm_deal`.`ID`
INNER JOIN `bizprofi_marsys_promotion_channel` `crm_deal_channel_deal_channel` ON `crm_deal_channel_deal`.`CHANNEL_ID` = `crm_deal_channel_deal_channel`.`ID`
WHERE `crm_deal`.`TYPE_ID` = 'SALE'
AND (
    (
        `crm_deal_channel_deal`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`
    )
    OR (
        UPPER(`crm_deal_channel_deal_channel`.`TREE_PATH`) like CONCAT("%.", `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, ".%") ESCAPE '!'
    )
)), 0) + IFNULL((SELECT
    SUM(`bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`AMOUNT`) AS `EXPENSE`
FROM `bizprofi_marsys_promotion_channel_payment_log` `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`
INNER JOIN `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_channel` ON `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_channel`.`ID`
WHERE (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`
    )
    OR (
        UPPER(`bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_channel`.`TREE_PATH`) like CONCAT("%.", `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, ".%") ESCAPE '!'
    )
)), 0)) <= 0) IS NULL OR ((IFNULL((SELECT
    COUNT(1) AS `INTERACTION`
FROM `b_crm_deal` `crm_deal`
INNER JOIN `bizprofi_marsys_promotion_channel_deal` `crm_deal_channel_deal` ON `crm_deal_channel_deal`.`DEAL_ID` = `crm_deal`.`ID`
INNER JOIN `bizprofi_marsys_promotion_channel` `crm_deal_channel_deal_channel` ON `crm_deal_channel_deal`.`CHANNEL_ID` = `crm_deal_channel_deal_channel`.`ID`
WHERE `crm_deal`.`TYPE_ID` = 'SALE'
AND (
    (
        `crm_deal_channel_deal`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`
    )
    OR (
        UPPER(`crm_deal_channel_deal_channel`.`TREE_PATH`) like CONCAT("%.", `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, ".%") ESCAPE '!'
    )
)), 0) + IFNULL((SELECT
    SUM(`bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`AMOUNT`) AS `EXPENSE`
FROM `bizprofi_marsys_promotion_channel_payment_log` `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`
INNER JOIN `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_channel` ON `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_channel`.`ID`
WHERE (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`
    )
    OR (
        UPPER(`bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_channel`.`TREE_PATH`) like CONCAT("%.", `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, ".%") ESCAPE '!'
    )
)), 0)) <= 0) = '')
GROUP BY `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, IF(@INCOME > 0, @INCOME - @EXPENSE, 0), IF(@LT_INCOME > 0, @LT_INCOME - @LT_EXPENSE, 0), IF(@EXPENSE > 0, ROUND((IF(@INCOME > 0, @INCOME - @EXPENSE, 0) - @EXPENSE) / @EXPENSE * 100), 0), IF(@LT_EXPENSE > 0, ROUND((IF(@LT_INCOME > 0, @LT_INCOME - @LT_EXPENSE, 0) - @LT_EXPENSE) / @LT_EXPENSE * 100), 0), IF(@INTERACTION > 0, ROUND(@EXPENSE / @INTERACTION), 0), IF(@SELLING > 0, ROUND(@EXPENSE / @SELLING), 0), IF(@INTERACTION > 0, ROUND(@SELLING / @INTERACTION * 100), 0), IF(@CLIENT > 0, ROUND(@EXPENSE / @CLIENT), 0), IF(@INTERACTION > 0, ROUND(@CLIENT / @INTERACTION * 100), 0), IF(@INTERACTION > 0, ROUND(@DEVICE_MOBILE_COUNT / @INTERACTION * 100, 2), 0), IF(@INTERACTION > 0, ROUND(@DEVICE_TABLET_COUNT / @INTERACTION * 100, 2), 0), IF(@INTERACTION > 0, ROUND(@DEVICE_TV_COUNT / @INTERACTION * 100, 2), 0), IF(@INTERACTION > 0, ROUND(@DEVICE_DESKTOP_COUNT / @INTERACTION * 100, 2), 0), (100 - (IF(@INTERACTION > 0, ROUND(@DEVICE_MOBILE_COUNT / @INTERACTION * 100, 2), 0) + IF(@INTERACTION > 0, ROUND(@DEVICE_TABLET_COUNT / @INTERACTION * 100, 2), 0) + IF(@INTERACTION > 0, ROUND(@DEVICE_TV_COUNT / @INTERACTION * 100, 2), 0) + IF(@INTERACTION > 0, ROUND(@DEVICE_DESKTOP_COUNT / @INTERACTION * 100, 2), 0))), (SELECT
    COUNT(1) AS `INTERACTION`
FROM `b_crm_deal` `crm_deal`
INNER JOIN `bizprofi_marsys_promotion_channel_deal` `crm_deal_channel_deal` ON `crm_deal_channel_deal`.`DEAL_ID` = `crm_deal`.`ID`
INNER JOIN `bizprofi_marsys_promotion_channel` `crm_deal_channel_deal_channel` ON `crm_deal_channel_deal`.`CHANNEL_ID` = `crm_deal_channel_deal_channel`.`ID`
WHERE `crm_deal`.`TYPE_ID` = 'SALE'
AND (
    (
        `crm_deal_channel_deal`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`
    )
    OR (
        UPPER(`crm_deal_channel_deal_channel`.`TREE_PATH`) like CONCAT("%.", `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, ".%") ESCAPE '!'
    )
)), (SELECT
    SUM(`bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`AMOUNT`) AS `EXPENSE`
FROM `bizprofi_marsys_promotion_channel_payment_log` `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`
INNER JOIN `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_channel` ON `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_channel`.`ID`
WHERE (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`
    )
    OR (
        UPPER(`bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_channel`.`TREE_PATH`) like CONCAT("%.", `bizprofi_marsyspromotion_datamanager_promotion_channel`.`ID`, ".%") ESCAPE '!'
    )
)), `bizprofi_marsyspromotion_datamanager_promotion_channel`.`DEPTH`, `bizprofi_marsyspromotion_datamanager_promotion_channel`.`TREE_PATH`, `bizprofi_marsyspromotion_datamanager_promotion_channel`.`PARENT`, `bizprofi_marsyspromotion_datamanager_promotion_channel`.`NAME`, `bizprofi_marsyspromotion_datamanager_promotion_channel`.`CODE`, `bizprofi_marsyspromotion_datamanager_promotion_channel`.`DEFAULT`, `bizprofi_marsyspromotion_datamanager_promotion_channel`.`SORT`
ORDER BY `SORT` ASC
LIMIT 0, 20
