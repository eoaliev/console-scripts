SELECT
    `s`.`TITLE` as `STAGE_TITLE`,
    IF(
        `u`.`NAME` IS NOT NULL
        AND LENGTH(`u`.`NAME`) > 0
        AND `u`.`LAST_NAME` IS NOT NULL
        AND LENGTH(`u`.`LAST_NAME`) > 0,
        CONCAT_WS(' ', `u`.`NAME`, `u`.`LAST_NAME`),
        `u`.`LOGIN`
    ) as `USER_TITLE`
FROM `b_tasks_stages` `s`
INNER JOIN `b_user` `u` ON `u`.`ID`=`s`.`ENTITY_ID`
WHERE `s`.`ENTITY_TYPE`='U'
ORDER BY
    `s`.`ENTITY_ID` ASC,
    `s`.`SORT` ASC
