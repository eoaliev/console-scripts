<?php

use Bitrix\Main\Application;
use Bitrix\Main\Config;
use Bitrix\Main\Db;
use Bitrix\Main\Loader;
use Magnifico\Site\Model;
use Magnifico\Site\Parser;

if (!Loader::includeModule('crm')) {
    var_dump('Not loaded crm');
    return;
}

if (!Loader::includeModule('magnifico.site')) {
    var_dump('Not loaded magnifico.site');
    return;
}

$connection = Application::getInstance()->getConnection();

$emailWheres = [];
foreach (json_decode(Config\Option::get('magnifico.site', 'emailtracker_froms', '[]'), true) as $from) {
    $emailWheres[] = new Db\SqlExpression("`a`.`SETTINGS` LIKE CONCAT('%', ?s '%')", $from);
}

$rows = $connection->query(new Db\SqlExpression(
    'SELECT `a`.*
    FROM `b_crm_act` `a`
    WHERE
        `a`.`TYPE_ID`=?i
        AND `a`.`DIRECTION`=?i'.
        (count($emailWheres) > 0 ? ' AND ('.implode(' OR ', $emailWheres).')': '').'
        ORDER BY `a`.`ID` DESC',
    \CCrmActivityType::Email,
    \CCrmActivityDirection::Incoming
));

if ($rows->getSelectedRowsCount() <= 0) {
    var_dump('Activities not found');
    return;
}

while ($row = $rows->fetch()) {
    $activity = Model\Activity::create($row);
    var_dump($activity->createEmailDeal());
}
