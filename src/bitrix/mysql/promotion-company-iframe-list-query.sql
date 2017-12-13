SELECT
    `crm_company`.`ID` AS `ID`,
    `crm_company`.`TITLE` AS `TITLE`,
    `crm_company`.`COMPANY_TYPE` AS `COMPANY_TYPE`,
    `crm_company`.`INDUSTRY` AS `INDUSTRY`,
    `crm_company`.`EMPLOYEES` AS `EMPLOYEES`,
    `crm_company`.`REVENUE` AS `REVENUE`,
    `crm_company`.`CURRENCY_ID` AS `CURRENCY_ID`,
    `crm_company`.`COMMENTS` AS `COMMENTS`,
    `crm_company`.`ADDRESS` AS `ADDRESS`,
    `crm_company`.`ADDRESS_LEGAL` AS `ADDRESS_LEGAL`,
    `crm_company`.`BANKING_DETAILS` AS `BANKING_DETAILS`,
    `crm_company`.`DATE_CREATE` AS `DATE_CREATE`,
    `crm_company`.`DATE_MODIFY` AS `DATE_MODIFY`,
    `crm_company`.`ASSIGNED_BY_ID` AS `ASSIGNED_BY_ID`,
    `crm_company`.`CREATED_BY_ID` AS `CREATED_BY_ID`,
    `crm_company`.`MODIFY_BY_ID` AS `MODIFY_BY_ID`,
    `crm_company`.`LEAD_ID` AS `LEAD_ID`,
    `crm_company`.`IS_MY_COMPANY` AS `IS_MY_COMPANY`,
    `crm_company`.`SEARCH_CONTENT` AS `SEARCH_CONTENT`,
    @INTERACTION:=(SELECT
    COUNT(1) AS `INTERACTION`
FROM `b_crm_deal` `crm_deal`

WHERE `crm_deal`.`TYPE_ID` = 'SALE'
AND `crm_deal`.`ID` IN (SELECT
    `bizprofi_marsyspromotion_datamanager_promotion_channel_deal`.`DEAL_ID` AS `DEAL_ID`
FROM `bizprofi_marsys_promotion_channel_deal` `bizprofi_marsyspromotion_datamanager_promotion_channel_deal`
INNER JOIN `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_channel_deal_channel` ON `bizprofi_marsyspromotion_datamanager_promotion_channel_deal`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel_deal_channel`.`ID`
WHERE (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_channel_deal`.`CHANNEL_ID` = '67'
    )
    OR (
        `bizprofi_marsyspromotion_datamanager_promotion_channel_deal_channel`.`TREE_PATH` like '%.67.%'
    )
))
AND `crm_deal`.`COMPANY_ID` = `crm_company`.`ID`) AS `__INTERACTION`,
    @SELLING:=(SELECT
    COUNT(1) AS `SELLING`
FROM `b_crm_deal` `crm_deal`

WHERE `crm_deal`.`TYPE_ID` = 'SALE'
AND `crm_deal`.`STAGE_ID` = 'WON'
AND `crm_deal`.`ID` IN (SELECT
    `bizprofi_marsyspromotion_datamanager_promotion_channel_deal`.`DEAL_ID` AS `DEAL_ID`
FROM `bizprofi_marsys_promotion_channel_deal` `bizprofi_marsyspromotion_datamanager_promotion_channel_deal`
INNER JOIN `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_channel_deal_channel` ON `bizprofi_marsyspromotion_datamanager_promotion_channel_deal`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel_deal_channel`.`ID`
WHERE (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_channel_deal`.`CHANNEL_ID` = '67'
    )
    OR (
        `bizprofi_marsyspromotion_datamanager_promotion_channel_deal_channel`.`TREE_PATH` like '%.67.%'
    )
))
AND `crm_deal`.`COMPANY_ID` = `crm_company`.`ID`) AS `__SELLING`,
    @INCOME:=(SELECT
    SUM(`crm_deal`.`OPPORTUNITY`) AS `INCOME`
FROM `b_crm_deal` `crm_deal`

WHERE `crm_deal`.`TYPE_ID` = 'SALE'
AND `crm_deal`.`STAGE_ID` = 'WON'
AND `crm_deal`.`ID` IN (SELECT
    `bizprofi_marsyspromotion_datamanager_promotion_channel_deal`.`DEAL_ID` AS `DEAL_ID`
FROM `bizprofi_marsys_promotion_channel_deal` `bizprofi_marsyspromotion_datamanager_promotion_channel_deal`
INNER JOIN `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_channel_deal_channel` ON `bizprofi_marsyspromotion_datamanager_promotion_channel_deal`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel_deal_channel`.`ID`
WHERE (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_channel_deal`.`CHANNEL_ID` = '67'
    )
    OR (
        `bizprofi_marsyspromotion_datamanager_promotion_channel_deal_channel`.`TREE_PATH` like '%.67.%'
    )
))
AND `crm_deal`.`COMPANY_ID` = `crm_company`.`ID`) AS `__INCOME`,
    @ANALOGIC:=(SELECT
    COUNT(DISTINCT `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`COMPANY_ID`) AS `ANALOGIC`
FROM `b_mp_company_binding` `bizprofi_marsyspromotion_datamanager_promotion_company_binding`
INNER JOIN `b_mp_company_binding` `bizprofi_marsyspromotion_datamanager_promotion_company_binding_company_binding` ON (
    `bizprofi_marsyspromotion_datamanager_promotion_company_binding_company_binding`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`CHANNEL_ID`
    OR `bizprofi_marsyspromotion_datamanager_promotion_company_binding_company_binding`.`PROJECT_ID` = `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`PROJECT_ID`
)
INNER JOIN `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_company_binding_channel` ON `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_company_binding_channel`.`ID`
WHERE (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`CHANNEL_ID` = '67'
    )
    OR (
        `bizprofi_marsyspromotion_datamanager_promotion_company_binding_channel`.`TREE_PATH` like '%.67.%'
    )
)
AND `bizprofi_marsyspromotion_datamanager_promotion_company_binding_company_binding`.`COMPANY_ID` = `crm_company`.`ID`) AS `__ANALOGIC`,
    @SUM_EXPENSE:=(SELECT
    SUM(DISTINCT `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`AMOUNT`) AS `SUM_EXPENSE`
FROM `bizprofi_marsys_promotion_channel_payment_log` `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`
INNER JOIN `b_mp_company_binding` `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_company_binding` ON (
    `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_company_binding`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`CHANNEL_ID`
    OR `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_company_binding`.`PROJECT_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`PROJECT_ID`
)
INNER JOIN `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_channel` ON `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_channel`.`ID`
WHERE (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`CHANNEL_ID` = '67'
    )
    OR (
        `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_channel`.`TREE_PATH` like '%.67.%'
    )
)
AND `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_company_binding`.`COMPANY_ID` = `crm_company`.`ID`) AS `__SUM_EXPENSE`,
    @DATE_LAST_INTERACTION:=(SELECT
    MAX(`crm_deal`.`DATE_CREATE`) AS `DATE_LAST_INTERACTION`
FROM `b_crm_deal` `crm_deal`

WHERE `crm_deal`.`TYPE_ID` = 'SALE'
AND `crm_deal`.`ID` IN (SELECT
    `bizprofi_marsyspromotion_datamanager_promotion_channel_deal`.`DEAL_ID` AS `DEAL_ID`
FROM `bizprofi_marsys_promotion_channel_deal` `bizprofi_marsyspromotion_datamanager_promotion_channel_deal`
INNER JOIN `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_channel_deal_channel` ON `bizprofi_marsyspromotion_datamanager_promotion_channel_deal`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel_deal_channel`.`ID`
WHERE (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_channel_deal`.`CHANNEL_ID` = '67'
    )
    OR (
        `bizprofi_marsyspromotion_datamanager_promotion_channel_deal_channel`.`TREE_PATH` like '%.67.%'
    )
))
AND `crm_deal`.`COMPANY_ID` = `crm_company`.`ID`) AS `__DATE_LAST_INTERACTION`,
    @METRIC_COUNT:=(SELECT
    COUNT(1) AS `METRIC_COUNT`
FROM `bizprofi_marsys_promotion_metric_company` `bizprofi_marsyspromotion_datamanager_promotion_metric_company`
INNER JOIN `b_mp_metric_binding` `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric_binding` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric_binding`.`METRIC_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`METRIC_ID`
INNER JOIN `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric_binding_channel` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric_binding`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric_binding_channel`.`ID`
WHERE (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric_binding`.`CHANNEL_ID` = '67'
    )
    OR (
        `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric_binding_channel`.`TREE_PATH` like '%.67.%'
    )
)
AND `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`COMPANY_ID` = `crm_company`.`ID`) AS `__METRIC_COUNT`,
    @BINDING_COUNT:=(SELECT
    COUNT(1) AS `BINDING_COUNT`
FROM `b_mp_company_binding` `bizprofi_marsyspromotion_datamanager_promotion_company_binding`
INNER JOIN `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_company_binding_channel` ON `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_company_binding_channel`.`ID`
WHERE (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`CHANNEL_ID` = '67'
    )
    OR (
        `bizprofi_marsyspromotion_datamanager_promotion_company_binding_channel`.`TREE_PATH` like '%.67.%'
    )
)
AND `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`COMPANY_ID` = `crm_company`.`ID`) AS `__BINDING_COUNT`,
    @LT_INCOME:=(SELECT
    SUM(`crm_deal`.`OPPORTUNITY`) AS `INCOME`
FROM `b_crm_deal` `crm_deal`

WHERE `crm_deal`.`TYPE_ID` = 'SALE'
AND `crm_deal`.`STAGE_ID` = 'WON'
AND `crm_deal`.`ID` IN (SELECT
    `bizprofi_marsyspromotion_datamanager_promotion_channel_deal`.`DEAL_ID` AS `DEAL_ID`
FROM `bizprofi_marsys_promotion_channel_deal` `bizprofi_marsyspromotion_datamanager_promotion_channel_deal`
INNER JOIN `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_channel_deal_channel` ON `bizprofi_marsyspromotion_datamanager_promotion_channel_deal`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel_deal_channel`.`ID`
WHERE (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_channel_deal`.`CHANNEL_ID` = '67'
    )
    OR (
        `bizprofi_marsyspromotion_datamanager_promotion_channel_deal_channel`.`TREE_PATH` like '%.67.%'
    )
))
AND `crm_deal`.`COMPANY_ID` = `crm_company`.`ID`) AS `__LT_INCOME`,
    @LT_ANALOGIC:=(SELECT
    COUNT(DISTINCT `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`COMPANY_ID`) AS `ANALOGIC`
FROM `b_mp_company_binding` `bizprofi_marsyspromotion_datamanager_promotion_company_binding`
INNER JOIN `b_mp_company_binding` `bizprofi_marsyspromotion_datamanager_promotion_company_binding_company_binding` ON (
    `bizprofi_marsyspromotion_datamanager_promotion_company_binding_company_binding`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`CHANNEL_ID`
    OR `bizprofi_marsyspromotion_datamanager_promotion_company_binding_company_binding`.`PROJECT_ID` = `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`PROJECT_ID`
)
INNER JOIN `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_company_binding_channel` ON `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_company_binding_channel`.`ID`
WHERE (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`CHANNEL_ID` = '67'
    )
    OR (
        `bizprofi_marsyspromotion_datamanager_promotion_company_binding_channel`.`TREE_PATH` like '%.67.%'
    )
)
AND `bizprofi_marsyspromotion_datamanager_promotion_company_binding_company_binding`.`COMPANY_ID` = `crm_company`.`ID`) AS `__LT_ANALOGIC`,
    @LT_SUM_EXPENSE:=(SELECT
    SUM(DISTINCT `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`AMOUNT`) AS `SUM_EXPENSE`
FROM `bizprofi_marsys_promotion_channel_payment_log` `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`
INNER JOIN `b_mp_company_binding` `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_company_binding` ON (
    `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_company_binding`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`CHANNEL_ID`
    OR `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_company_binding`.`PROJECT_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`PROJECT_ID`
)
INNER JOIN `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_channel` ON `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_channel`.`ID`
WHERE (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`CHANNEL_ID` = '67'
    )
    OR (
        `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_channel`.`TREE_PATH` like '%.67.%'
    )
)
AND `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_company_binding`.`COMPANY_ID` = `crm_company`.`ID`) AS `__LT_SUM_EXPENSE`,
    @DEVICE_MOBILE_COUNT:=(SELECT
    COUNT(DISTINCT 1) AS `METRIC_COUNT`
FROM `bizprofi_marsys_promotion_metric_company` `bizprofi_marsyspromotion_datamanager_promotion_metric_company`
INNER JOIN `b_mp_company_binding` `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding`.`COMPANY_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`COMPANY_ID`
INNER JOIN `bizprofi_marsys_promotion_metric_deal` `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric_deal` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric_deal`.`METRIC_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`METRIC_ID`
INNER JOIN `b_crm_deal` `bizprofi_marsyspromotion_datamanager_promotion_metric_company_deal` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_company_deal`.`ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric_deal`.`DEAL_ID`
AND `bizprofi_marsyspromotion_datamanager_promotion_metric_company_deal`.`COMPANY_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`COMPANY_ID`
INNER JOIN `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding_channel` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding_channel`.`ID`
INNER JOIN `bizprofi_marsys_promotion_metric` `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`METRIC_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric`.`ID`
WHERE `bizprofi_marsyspromotion_datamanager_promotion_metric_company_deal`.`TYPE_ID` = 'SALE'
AND (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding`.`CHANNEL_ID` = '67'
    )
    OR (
        `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding_channel`.`TREE_PATH` like '%.67.%'
    )
)
AND `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric`.`DEVICE` in ('mobile', 'мобильный телефон')
AND `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`COMPANY_ID` = `crm_company`.`ID`) AS `__DEVICE_MOBILE_COUNT`,
    @DEVICE_TABLET_COUNT:=(SELECT
    COUNT(DISTINCT 1) AS `METRIC_COUNT`
FROM `bizprofi_marsys_promotion_metric_company` `bizprofi_marsyspromotion_datamanager_promotion_metric_company`
INNER JOIN `b_mp_company_binding` `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding`.`COMPANY_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`COMPANY_ID`
INNER JOIN `bizprofi_marsys_promotion_metric_deal` `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric_deal` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric_deal`.`METRIC_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`METRIC_ID`
INNER JOIN `b_crm_deal` `bizprofi_marsyspromotion_datamanager_promotion_metric_company_deal` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_company_deal`.`ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric_deal`.`DEAL_ID`
AND `bizprofi_marsyspromotion_datamanager_promotion_metric_company_deal`.`COMPANY_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`COMPANY_ID`
INNER JOIN `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding_channel` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding_channel`.`ID`
INNER JOIN `bizprofi_marsys_promotion_metric` `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`METRIC_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric`.`ID`
WHERE `bizprofi_marsyspromotion_datamanager_promotion_metric_company_deal`.`TYPE_ID` = 'SALE'
AND (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding`.`CHANNEL_ID` = '67'
    )
    OR (
        `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding_channel`.`TREE_PATH` like '%.67.%'
    )
)
AND `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric`.`DEVICE` = 'tablet'
AND `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`COMPANY_ID` = `crm_company`.`ID`) AS `__DEVICE_TABLET_COUNT`,
    @DEVICE_TV_COUNT:=(SELECT
    COUNT(DISTINCT 1) AS `METRIC_COUNT`
FROM `bizprofi_marsys_promotion_metric_company` `bizprofi_marsyspromotion_datamanager_promotion_metric_company`
INNER JOIN `b_mp_company_binding` `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding`.`COMPANY_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`COMPANY_ID`
INNER JOIN `bizprofi_marsys_promotion_metric_deal` `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric_deal` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric_deal`.`METRIC_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`METRIC_ID`
INNER JOIN `b_crm_deal` `bizprofi_marsyspromotion_datamanager_promotion_metric_company_deal` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_company_deal`.`ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric_deal`.`DEAL_ID`
AND `bizprofi_marsyspromotion_datamanager_promotion_metric_company_deal`.`COMPANY_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`COMPANY_ID`
INNER JOIN `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding_channel` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding_channel`.`ID`
INNER JOIN `bizprofi_marsys_promotion_metric` `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`METRIC_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric`.`ID`
WHERE `bizprofi_marsyspromotion_datamanager_promotion_metric_company_deal`.`TYPE_ID` = 'SALE'
AND (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding`.`CHANNEL_ID` = '67'
    )
    OR (
        `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding_channel`.`TREE_PATH` like '%.67.%'
    )
)
AND `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric`.`DEVICE` = 'tv'
AND `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`COMPANY_ID` = `crm_company`.`ID`) AS `__DEVICE_TV_COUNT`,
    @DEVICE_DESKTOP_COUNT:=(SELECT
    COUNT(DISTINCT 1) AS `METRIC_COUNT`
FROM `bizprofi_marsys_promotion_metric_company` `bizprofi_marsyspromotion_datamanager_promotion_metric_company`
INNER JOIN `b_mp_company_binding` `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding`.`COMPANY_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`COMPANY_ID`
INNER JOIN `bizprofi_marsys_promotion_metric_deal` `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric_deal` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric_deal`.`METRIC_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`METRIC_ID`
INNER JOIN `b_crm_deal` `bizprofi_marsyspromotion_datamanager_promotion_metric_company_deal` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_company_deal`.`ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric_deal`.`DEAL_ID`
AND `bizprofi_marsyspromotion_datamanager_promotion_metric_company_deal`.`COMPANY_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`COMPANY_ID`
INNER JOIN `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding_channel` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding_channel`.`ID`
INNER JOIN `bizprofi_marsys_promotion_metric` `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric` ON `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`METRIC_ID` = `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric`.`ID`
WHERE `bizprofi_marsyspromotion_datamanager_promotion_metric_company_deal`.`TYPE_ID` = 'SALE'
AND (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding`.`CHANNEL_ID` = '67'
    )
    OR (
        `bizprofi_marsyspromotion_datamanager_promotion_metric_company_company_binding_channel`.`TREE_PATH` like '%.67.%'
    )
)
AND `bizprofi_marsyspromotion_datamanager_promotion_metric_company_metric`.`DEVICE` = 'desktop'
AND `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`COMPANY_ID` = `crm_company`.`ID`) AS `__DEVICE_DESKTOP_COUNT`,
    @PROJECT_ID:=(SELECT
    `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`PROJECT_ID` AS `PROJECT_ID`
FROM `b_mp_company_binding` `bizprofi_marsyspromotion_datamanager_promotion_company_binding`

WHERE `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`COMPANY_ID` = `crm_company`.`ID`
ORDER BY `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`CREATION_DATE` DESC
LIMIT 0, 1
) AS `__PROJECT_ID`,
    @CHANNEL_ID:=(SELECT
    `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`CHANNEL_ID` AS `CHANNEL_ID`
FROM `b_mp_company_binding` `bizprofi_marsyspromotion_datamanager_promotion_company_binding`

WHERE `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`COMPANY_ID` = `crm_company`.`ID`
ORDER BY `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`CREATION_DATE` DESC
LIMIT 0, 1
) AS `__CHANNEL_ID`,
    @INTERACTION AS `INTERACTION`,
    @SELLING AS `SELLING`,
    @INCOME AS `INCOME`,
    @DATE_LAST_INTERACTION AS `DATE_LAST_INTERACTION`,
    @METRIC_COUNT AS `METRIC_COUNT`,
    @BINDING_COUNT AS `BINDING_COUNT`,
    @PROJECT_ID AS `PROJECT_ID`,
    @CHANNEL_ID AS `CHANNEL_ID`,
    @ANALOGIC AS `ANALOGIC`,
    @SUM_EXPENSE AS `SUM_EXPENSE`,
    @LT_INCOME AS `LT_INCOME`,
    @LT_ANALOGIC AS `LT_ANALOGIC`,
    @LT_SUM_EXPENSE AS `LT_SUM_EXPENSE`,
    @DEVICE_MOBILE_COUNT AS `DEVICE_MOBILE_COUNT`,
    @DEVICE_TABLET_COUNT AS `DEVICE_TABLET_COUNT`,
    @DEVICE_TV_COUNT AS `DEVICE_TV_COUNT`,
    @DEVICE_DESKTOP_COUNT AS `DEVICE_DESKTOP_COUNT`,
    IF(@LT_ANALOGIC > 0, ROUND(@LT_SUM_EXPENSE / @LT_ANALOGIC), 0) AS `LT_EXPENSE`,
    IF(@ANALOGIC > 0, ROUND(@SUM_EXPENSE / @ANALOGIC), 0) AS `EXPENSE`,
    IF(@INCOME > 0, @INCOME - IF(@ANALOGIC > 0, ROUND(@SUM_EXPENSE / @ANALOGIC), 0), 0) AS `PROFIT`,
    IF(@LT_INCOME > 0, @LT_INCOME - IF(@LT_ANALOGIC > 0, ROUND(@LT_SUM_EXPENSE / @LT_ANALOGIC), 0), 0) AS `LTV`,
    IF(IF(@ANALOGIC > 0, ROUND(@SUM_EXPENSE / @ANALOGIC), 0) > 0, ROUND((IF(@INCOME > 0, @INCOME - IF(@ANALOGIC > 0, ROUND(@SUM_EXPENSE / @ANALOGIC), 0), 0) - IF(@ANALOGIC > 0, ROUND(@SUM_EXPENSE / @ANALOGIC), 0)) / IF(@ANALOGIC > 0, ROUND(@SUM_EXPENSE / @ANALOGIC), 0) * 100), 0) AS `ROI`,
    IF(IF(@LT_ANALOGIC > 0, ROUND(@LT_SUM_EXPENSE / @LT_ANALOGIC), 0) > 0, ROUND((IF(@LT_INCOME > 0, @LT_INCOME - IF(@LT_ANALOGIC > 0, ROUND(@LT_SUM_EXPENSE / @LT_ANALOGIC), 0), 0) - IF(@LT_ANALOGIC > 0, ROUND(@LT_SUM_EXPENSE / @LT_ANALOGIC), 0)) / IF(@LT_ANALOGIC > 0, ROUND(@LT_SUM_EXPENSE / @LT_ANALOGIC), 0) * 100), 0) AS `LT_ROI`,
    IF(@INTERACTION > 0, ROUND(IF(@ANALOGIC > 0, ROUND(@SUM_EXPENSE / @ANALOGIC), 0) / @INTERACTION), 0) AS `INTERACTION_EXPENSE`,
    IF(@SELLING > 0, ROUND(IF(@ANALOGIC > 0, ROUND(@SUM_EXPENSE / @ANALOGIC), 0) / @SELLING), 0) AS `SELLING_EXPENSE`,
    IF(@INTERACTION > 0, ROUND(@SELLING / @INTERACTION * 100), 0) AS `SELLING_CONVERSION`,
    IF(@INTERACTION > 0, ROUND(@DEVICE_MOBILE_COUNT / @INTERACTION * 100, 2), 0) AS `DEVICE_MOBILE`,
    IF(@INTERACTION > 0, ROUND(@DEVICE_TABLET_COUNT / @INTERACTION * 100, 2), 0) AS `DEVICE_TABLET`,
    IF(@INTERACTION > 0, ROUND(@DEVICE_TV_COUNT / @INTERACTION * 100, 2), 0) AS `DEVICE_TV`,
    IF(@INTERACTION > 0, ROUND(@DEVICE_DESKTOP_COUNT / @INTERACTION * 100, 2), 0) AS `DEVICE_DESKTOP`,
    (100 - (IF(@INTERACTION > 0, ROUND(@DEVICE_MOBILE_COUNT / @INTERACTION * 100, 2), 0) + IF(@INTERACTION > 0, ROUND(@DEVICE_TABLET_COUNT / @INTERACTION * 100, 2), 0) + IF(@INTERACTION > 0, ROUND(@DEVICE_TV_COUNT / @INTERACTION * 100, 2), 0) + IF(@INTERACTION > 0, ROUND(@DEVICE_DESKTOP_COUNT / @INTERACTION * 100, 2), 0))) AS `DEVICE_OTHER`
FROM `b_crm_company` `crm_company`

WHERE `crm_company`.`ID` IN (SELECT
    `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`COMPANY_ID` AS `COMPANY_ID`
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
        `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`CHANNEL_ID` = '67'
    )
    OR (
        `bizprofi_marsyspromotion_datamanager_promotion_company_binding_channel`.`TREE_PATH` like '%.67.%'
    )
))
ORDER BY `ID` ASC
LIMIT 0, 20
