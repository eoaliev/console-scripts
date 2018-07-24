SELECT
    CONCAT_WS(' ', `u`.`NAME`, `u`.`LAST_NAME`) AS `RESPONSIBLE`,
    CONCAT(
        ROUND(`p`.`TIME_ESTIMATE` / 60),
        ' мин.'
    ) AS `TIME_ESTIMATE`,
    CONCAT(
        ROUND(
            AVG(
                IF(
                    `p`.`TIME_ESTIMATE` > 0,
                    (
                        (
                            SELECT
                                SUM(`e`.`SECONDS`)
                            FROM `b_tasks_elapsed_time` `e`
                            WHERE
                                `e`.`TASK_ID`=`t`.`ID`
                            GROUP BY
                                `e`.`TASK_ID`
                        ) * 100 / `p`.`TIME_ESTIMATE`
                    ),
                    NULL
                )
            ),
            2
        ),
        '%'
    ) AS `PERCENT`,
    COUNT(`t`.`ID`) AS `TASK_COUNT`
FROM `b_tasks` `t`
INNER JOIN `b_tasks` `p` ON `p`.`ID`=`t`.`PARENT_ID`
INNER JOIN `b_user` `u` ON `u`.`ID`=`t`.`RESPONSIBLE_ID`
WHERE
    `t`.`TITLE` LIKE 'Ревью%'
GROUP BY
    `t`.`RESPONSIBLE_ID`,
    `p`.`TIME_ESTIMATE`;

-- Version 2
SELECT
    CONCAT_WS(' ', `u`.`NAME`, `u`.`LAST_NAME`) AS `RESPONSIBLE`,
    CONCAT(
        ROUND(`p`.`TIME_ESTIMATE` / 60),
        ' мин.'
    ) AS `TIME_ESTIMATE`,
    CONCAT(
        ROUND(
            AVG(
                IF(
                    `p`.`TIME_ESTIMATE` > 0,
                    (
                        `e`.`SECONDS` * 100 / `p`.`TIME_ESTIMATE`
                    ),
                    NULL
                )
            ),
            2
        ),
        '%'
    ) AS `PERCENT`,
    COUNT(`t`.`ID`) AS `TASK_COUNT`
FROM `b_tasks` `t`
INNER JOIN `b_tasks` `p` ON `p`.`ID`=`t`.`PARENT_ID`
INNER JOIN (
    SELECT
        `TASK_ID` AS `TASK_ID`,
        `USER_ID` AS `USER_ID`,
        SUM(`SECONDS`) AS `SECONDS`
    FROM `b_tasks_elapsed_time`
    GROUP BY
        `TASK_ID`,
        `USER_ID`
) `e` ON `e`.`TASK_ID`=`t`.`ID`
INNER JOIN `b_user` `u` ON `u`.`ID`=`e`.`USER_ID`
WHERE
    `t`.`TITLE` LIKE 'Ревью%'
GROUP BY
    `e`.`USER_ID`,
    `p`.`TIME_ESTIMATE`;

