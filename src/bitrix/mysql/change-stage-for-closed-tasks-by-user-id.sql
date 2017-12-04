UPDATE `b_tasks_task_stage` `ts`
INNER JOIN `b_tasks` `t` ON `t`.`ID`=`ts`.`TASK_ID`
INNER JOIN `b_tasks_stages` `s` ON `s`.`ID`=`ts`.`STAGE_ID`
SET `ts`.`STAGE_ID`=119
WHERE
    `t`.`STATUS` IN (2, 4, 5) AND
    `t`.`RESPONSIBLE_ID`=17 AND
    `s`.`ENTITY_TYPE`='U' AND
    `s`.`ENTITY_ID`=17
