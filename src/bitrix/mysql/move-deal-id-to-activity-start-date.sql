SELECT
    `d`.`ID`,
    `d`.`DATE_CREATE`,
    `a`.`START_TIME`
FROM `b_crm_deal` `d`
INNER JOIN `b_crm_act_bind` `ab` ON `ab`.`OWNER_ID`=`d`.`ID`
INNER JOIN `b_crm_act` `a` ON `a`.`ID`=`ab`.`ACTIVITY_ID`
WHERE
    `a`.`DIRECTION`=1
    AND `a`.`TYPE_ID`=4
    AND `ab`.`OWNER_TYPE_ID`=2
ORDER BY `d`.`ID` DESC

UPDATE `b_crm_deal` `d`
INNER JOIN `b_crm_act_bind` `ab` ON `ab`.`OWNER_ID`=`d`.`ID`
INNER JOIN `b_crm_act` `a` ON `a`.`ID`=`ab`.`ACTIVITY_ID`
SET
    `d`.`DATE_CREATE`=`a`.`START_TIME`
WHERE
    `a`.`DIRECTION`=1
    AND `a`.`TYPE_ID`=4
    AND `ab`.`OWNER_TYPE_ID`=2
