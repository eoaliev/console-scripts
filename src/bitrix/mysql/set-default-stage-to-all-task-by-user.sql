-- Select all by user
SELECT *
FROM `b_tasks_task_stage` `ts`
INNER JOIN `b_tasks_stages` `s` ON `s`.`ID`=`ts`.`STAGE_ID`
WHERE
    `s`.`ID`!=25
    AND `s`.`ENTITY_ID`=17
    AND `s`.`ENTITY_TYPE`='U'

-- Update all by user
UPDATE `b_tasks_task_stage` `ts`
INNER JOIN `b_tasks_stages` `s` ON `s`.`ID`=`ts`.`STAGE_ID`
SET
    `ts`.`STAGE_ID`=25
WHERE
    `s`.`ID`!=25
    AND `s`.`ENTITY_ID`=17
    AND `s`.`ENTITY_TYPE`='U'
