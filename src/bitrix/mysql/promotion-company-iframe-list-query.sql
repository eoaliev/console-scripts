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

    `interaction`.`INTERACTION` AS `INTERACTION`,
    `selling`.`SELLING` AS `SELLING`,
    `income`.`INCOME` AS `INCOME`,
    `date_last_interaction`.`DATE_LAST_INTERACTION` AS `DATE_LAST_INTERACTION`,
    `metric_count`.`METRIC_COUNT` AS `METRIC_COUNT`,
    `binding_count`.`BINDING_COUNT` AS `BINDING_COUNT`,
    -- `project_id`.`PROJECT_ID` AS `PROJECT_ID`,
    -- `channel_id`.`CHANNEL_ID` AS `CHANNEL_ID`,
    `analogic`.`ANALOGIC` AS `ANALOGIC`,
    `sum_expense`.`SUM_EXPENSE` AS `SUM_EXPENSE`,
    `lt_income`.`INCOME` AS `LT_INCOME`,
    `lt_analogic`.`ANALOGIC` AS `LT_ANALOGIC`,
    `lt_sum_expense`.`SUM_EXPENSE` AS `LT_SUM_EXPENSE`,
    `device_mobile_count`.`METRIC_COUNT` AS `DEVICE_MOBILE_COUNT`,
    `device_tablet_count`.`METRIC_COUNT` AS `DEVICE_TABLET_COUNT`,
    `device_tv_count`.`METRIC_COUNT` AS `DEVICE_TV_COUNT`,
    `device_desktop_count`.`METRIC_COUNT` AS `DEVICE_DESKTOP_COUNT`,
    IF(`lt_analogic`.`ANALOGIC` > 0, ROUND(`lt_sum_expense`.`SUM_EXPENSE` / `lt_analogic`.`ANALOGIC`), 0) AS `LT_EXPENSE`,
    IF(`analogic`.`ANALOGIC` > 0, ROUND(`sum_expense`.`SUM_EXPENSE` / `analogic`.`ANALOGIC`), 0) AS `EXPENSE`,
    IF(`income`.`INCOME` > 0, `income`.`INCOME` - IF(`analogic`.`ANALOGIC` > 0, ROUND(`sum_expense`.`SUM_EXPENSE` / `analogic`.`ANALOGIC`), 0), 0) AS `PROFIT`,
    IF(`lt_income`.`INCOME` > 0, `lt_income`.`INCOME` - IF(`lt_analogic`.`ANALOGIC` > 0, ROUND(`lt_sum_expense`.`SUM_EXPENSE` / `lt_analogic`.`ANALOGIC`), 0), 0) AS `LTV`,
    IF(IF(`analogic`.`ANALOGIC` > 0, ROUND(`sum_expense`.`SUM_EXPENSE` / `analogic`.`ANALOGIC`), 0) > 0, ROUND((IF(`income`.`INCOME` > 0, `income`.`INCOME` - IF(`analogic`.`ANALOGIC` > 0, ROUND(`sum_expense`.`SUM_EXPENSE` / `analogic`.`ANALOGIC`), 0), 0) - IF(`analogic`.`ANALOGIC` > 0, ROUND(`sum_expense`.`SUM_EXPENSE` / `analogic`.`ANALOGIC`), 0)) / IF(`analogic`.`ANALOGIC` > 0, ROUND(`sum_expense`.`SUM_EXPENSE` / `analogic`.`ANALOGIC`), 0) * 100), 0) AS `ROI`,
    IF(IF(`lt_analogic`.`ANALOGIC` > 0, ROUND(`lt_sum_expense`.`SUM_EXPENSE` / `lt_analogic`.`ANALOGIC`), 0) > 0, ROUND((IF(`lt_income`.`INCOME` > 0, `lt_income`.`INCOME` - IF(`lt_analogic`.`ANALOGIC` > 0, ROUND(`lt_sum_expense`.`SUM_EXPENSE` / `lt_analogic`.`ANALOGIC`), 0), 0) - IF(`lt_analogic`.`ANALOGIC` > 0, ROUND(`lt_sum_expense`.`SUM_EXPENSE` / `lt_analogic`.`ANALOGIC`), 0)) / IF(`lt_analogic`.`ANALOGIC` > 0, ROUND(`lt_sum_expense`.`SUM_EXPENSE` / `lt_analogic`.`ANALOGIC`), 0) * 100), 0) AS `LT_ROI`,
    IF(`interaction`.`INTERACTION` > 0, ROUND(IF(`analogic`.`ANALOGIC` > 0, ROUND(`sum_expense`.`SUM_EXPENSE` / `analogic`.`ANALOGIC`), 0) / `interaction`.`INTERACTION`), 0) AS `INTERACTION_EXPENSE`,
    IF(`selling`.`SELLING` > 0, ROUND(IF(`analogic`.`ANALOGIC` > 0, ROUND(`sum_expense`.`SUM_EXPENSE` / `analogic`.`ANALOGIC`), 0) / `selling`.`SELLING`), 0) AS `SELLING_EXPENSE`,
    IF(`interaction`.`INTERACTION` > 0, ROUND(`selling`.`SELLING` / `interaction`.`INTERACTION` * 100), 0) AS `SELLING_CONVERSION`,
    IF(`interaction`.`INTERACTION` > 0, ROUND(`device_mobile_count`.`METRIC_COUNT` / `interaction`.`INTERACTION` * 100, 2), 0) AS `DEVICE_MOBILE`,
    IF(`interaction`.`INTERACTION` > 0, ROUND(`device_tablet_count`.`METRIC_COUNT` / `interaction`.`INTERACTION` * 100, 2), 0) AS `DEVICE_TABLET`,
    IF(`interaction`.`INTERACTION` > 0, ROUND(`device_tv_count`.`METRIC_COUNT` / `interaction`.`INTERACTION` * 100, 2), 0) AS `DEVICE_TV`,
    IF(`interaction`.`INTERACTION` > 0, ROUND(`device_desktop_count`.`METRIC_COUNT` / `interaction`.`INTERACTION` * 100, 2), 0) AS `DEVICE_DESKTOP`,
    (100 - (IF(`interaction`.`INTERACTION` > 0, ROUND(`device_mobile_count`.`METRIC_COUNT` / `interaction`.`INTERACTION` * 100, 2), 0) + IF(`interaction`.`INTERACTION` > 0, ROUND(`device_tablet_count`.`METRIC_COUNT` / `interaction`.`INTERACTION` * 100, 2), 0) + IF(`interaction`.`INTERACTION` > 0, ROUND(`device_tv_count`.`METRIC_COUNT` / `interaction`.`INTERACTION` * 100, 2), 0) + IF(`interaction`.`INTERACTION` > 0, ROUND(`device_desktop_count`.`METRIC_COUNT` / `interaction`.`INTERACTION` * 100, 2), 0))) AS `DEVICE_OTHER`
FROM `b_crm_company` `crm_company`

-- Join interaction
LEFT JOIN (SELECT
    COUNT(1) AS `INTERACTION`,
    `crm_deal`.`COMPANY_ID` AS `COMPANY_ID`
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
GROUP BY `crm_deal`.`COMPANY_ID`) `interaction` ON `interaction`.`COMPANY_ID` = `crm_company`.`ID`

-- Join selling
LEFT JOIN (SELECT
    COUNT(1) AS `SELLING`,
    `crm_deal`.`COMPANY_ID` AS `COMPANY_ID`
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
GROUP BY `crm_deal`.`COMPANY_ID`) `selling` ON `selling`.`COMPANY_ID` = `crm_company`.`ID`

-- Join income
LEFT JOIN (SELECT
    SUM(`crm_deal`.`OPPORTUNITY`) AS `INCOME`,
    `crm_deal`.`COMPANY_ID` AS `COMPANY_ID`
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
GROUP BY `crm_deal`.`COMPANY_ID`) `income` ON `income`.`COMPANY_ID` = `crm_company`.`ID`

-- Join analogic
LEFT JOIN (SELECT
    COUNT(DISTINCT `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`COMPANY_ID`) AS `ANALOGIC`,
    `bizprofi_marsyspromotion_datamanager_promotion_company_binding_company_binding`.`COMPANY_ID` AS `COMPANY_ID`
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
GROUP BY `bizprofi_marsyspromotion_datamanager_promotion_company_binding_company_binding`.`COMPANY_ID`) `analogic` ON `analogic`.`COMPANY_ID`=`crm_company`.`ID`

-- Join sum_expense
LEFT JOIN (SELECT
    SUM(DISTINCT `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`AMOUNT`) AS `SUM_EXPENSE`,
    `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_company_binding`.`COMPANY_ID` AS `COMPANY_ID`
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
GROUP BY `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_company_binding`.`COMPANY_ID`) `sum_expense` ON `sum_expense`.`COMPANY_ID`=`crm_company`.`ID`

-- Join date_last_interaction
LEFT JOIN (SELECT
    MAX(`crm_deal`.`DATE_CREATE`) AS `DATE_LAST_INTERACTION`,
    `crm_deal`.`COMPANY_ID` AS `COMPANY_ID`
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
GROUP BY `crm_deal`.`COMPANY_ID`) `date_last_interaction` ON `date_last_interaction`.`COMPANY_ID`=`crm_company`.`ID`

-- Join metric_count
LEFT JOIN (SELECT
    COUNT(1) AS `METRIC_COUNT`,
    `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`COMPANY_ID` AS `COMPANY_ID`
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
GROUP BY `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`COMPANY_ID`) `metric_count` ON `metric_count`.`COMPANY_ID`=`crm_company`.`ID`

-- Join binding_count
LEFT JOIN (SELECT
    COUNT(1) AS `BINDING_COUNT`,
    `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`COMPANY_ID` AS `COMPANY_ID`
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
GROUP BY `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`COMPANY_ID`) `binding_count` ON `binding_count`.`COMPANY_ID`=`crm_company`.`ID`

-- Join lt_income
LEFT JOIN (SELECT
    SUM(`crm_deal`.`OPPORTUNITY`) AS `INCOME`,
    `crm_deal`.`COMPANY_ID` AS `COMPANY_ID`
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
GROUP BY `crm_deal`.`COMPANY_ID`) `lt_income` ON `lt_income`.`COMPANY_ID`=`crm_company`.`ID`

-- Join lt_analogic
LEFT JOIN (SELECT
    COUNT(DISTINCT `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`COMPANY_ID`) AS `ANALOGIC`,
    `bizprofi_marsyspromotion_datamanager_promotion_company_binding_company_binding`.`COMPANY_ID` AS `COMPANY_ID`
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
GROUP BY `bizprofi_marsyspromotion_datamanager_promotion_company_binding_company_binding`.`COMPANY_ID`) `lt_analogic` ON `lt_analogic`.`COMPANY_ID`=`crm_company`.`ID`

-- Join lt_sum_expense
LEFT JOIN (SELECT
    SUM(DISTINCT `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log`.`AMOUNT`) AS `SUM_EXPENSE`,
    `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_company_binding`.`COMPANY_ID` AS `COMPANY_ID`
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
GROUP BY `bizprofi_marsyspromotion_datamanager_promotion_channel_payment_log_company_binding`.`COMPANY_ID`) `lt_sum_expense` ON `lt_sum_expense`.`COMPANY_ID`=`crm_company`.`ID`

-- Join device_mobile_count
LEFT JOIN (SELECT
    COUNT(DISTINCT 1) AS `METRIC_COUNT`,
    `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`COMPANY_ID` AS `COMPANY_ID`
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
GROUP BY `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`COMPANY_ID`) `device_mobile_count` ON `device_mobile_count`.`COMPANY_ID`=`crm_company`.`ID`

-- Join device_tablet_count
LEFT JOIN (SELECT
    COUNT(DISTINCT 1) AS `METRIC_COUNT`,
    `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`COMPANY_ID` AS `COMPANY_ID`
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
GROUP BY `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`COMPANY_ID`) `device_tablet_count` ON `device_tablet_count`.`COMPANY_ID`=`crm_company`.`ID`

-- Join device_tv_count
LEFT JOIN (SELECT
    COUNT(DISTINCT 1) AS `METRIC_COUNT`,
    `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`COMPANY_ID` AS `COMPANY_ID`
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
GROUP BY `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`COMPANY_ID`) `device_tv_count` ON `device_tv_count`.`COMPANY_ID`=`crm_company`.`ID`

-- Join device_desktop_count
LEFT JOIN (SELECT
    COUNT(DISTINCT 1) AS `METRIC_COUNT`,
    `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`COMPANY_ID` AS `COMPANY_ID`
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
GROUP BY `bizprofi_marsyspromotion_datamanager_promotion_metric_company`.`COMPANY_ID`) `device_desktop_count` ON `device_desktop_count`.`COMPANY_ID`=`crm_company`.`ID`

-- -- Join project_id
-- LEFT JOIN (SELECT
--     `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`PROJECT_ID` AS `PROJECT_ID`
-- FROM `b_mp_company_binding` `bizprofi_marsyspromotion_datamanager_promotion_company_binding`

-- WHERE `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`COMPANY_ID` = `crm_company`.`ID`
-- ORDER BY `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`CREATION_DATE` DESC
-- LIMIT 0, 1
-- ) `project_id` ON `project_id`.`COMPANY_ID`=`crm_company`.`ID`

-- -- Join channel_id
-- LEFT JOIN (SELECT
--     `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`CHANNEL_ID` AS `CHANNEL_ID`
-- FROM `b_mp_company_binding` `bizprofi_marsyspromotion_datamanager_promotion_company_binding`

-- WHERE `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`COMPANY_ID` = `crm_company`.`ID`
-- ORDER BY `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`CREATION_DATE` DESC
-- LIMIT 0, 1
-- ) `channel_id` ON `channel_id`.`COMPANY_ID`=`crm_company`.`ID`




WHERE `crm_company`.`ID` IN (SELECT
    `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`COMPANY_ID` AS `COMPANY_ID`
FROM `b_mp_company_binding` `bizprofi_marsyspromotion_datamanager_promotion_company_binding`
LEFT JOIN `b_crm_deal` `bizprofi_marsyspromotion_datamanager_promotion_company_binding_deal` ON `bizprofi_marsyspromotion_datamanager_promotion_company_binding_deal`.`ID` = `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`ENTITY_ID`
AND `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`ENTITY_TYPE` = 'D'
LEFT JOIN `bizprofi_marsys_promotion_metric_deal` `bizprofi_marsyspromotion_datamanager_promotion_company_binding_metric_deal` ON `bizprofi_marsyspromotion_datamanager_promotion_company_binding_metric_deal`.`METRIC_ID` = `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`ENTITY_ID`
AND `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`ENTITY_TYPE` = 'M'
LEFT JOIN `b_crm_deal` `bizprofi_marsyspromotion_datamanager_promotion_company_binding_metric_deal_deal` ON `bizprofi_marsyspromotion_datamanager_promotion_company_binding_metric_deal_deal`.`ID` = `bizprofi_marsyspromotion_datamanager_promotion_company_binding_metric_deal`.`DEAL_ID`
INNER JOIN `bizprofi_marsys_promotion_channel` `bizprofi_marsyspromotion_datamanager_promotion_company_binding_channel` ON `bizprofi_marsyspromotion_datamanager_promotion_company_binding`.`CHANNEL_ID` = `bizprofi_marsyspromotion_datamanager_promotion_company_binding_channel`.`ID`
WHERE (
    (
        `bizprofi_marsyspromotion_datamanager_promotion_company_binding_deal`.`TYPE_ID` = 'SALE'
    )
    OR (
        `bizprofi_marsyspromotion_datamanager_promotion_company_binding_metric_deal_deal`.`TYPE_ID` = 'SALE'
    )
)
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
