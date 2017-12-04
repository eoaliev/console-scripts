UPDATE `b_tasks_task_stage` `ts`
INNER JOIN `b_tasks_task` `t` ON `t`.`ID`=`ts`.`TASK_ID`
SET `ts`.`STAGE_ID`=119
WHERE
    `t`.`STATUS`=2,
    `t`.`CREATED_BY`=17
