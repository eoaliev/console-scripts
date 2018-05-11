<?php

if (!\Bitrix\Main\Loader::includeModule('tasks')) {
    var_dump('Fail loaded tasks');
    return;
}

// To all employees
// if (!\Bitrix\Main\Loader::includeModule('intranet')) {
//     var_dump('Fail loaded intranet');
//     return;
// }

// $employees = Bitrix\Intranet\Util::getEmployeesList(['SITE_ID' => 's1']);

// $responsibles = [];
// foreach ($employees as $employee) {
//     $responsibles[] = ['ID' => $employee['ID']];
// }

// To current employee
$responsibles = [['ID' => $GLOBALS['USER']->getId()]];

$result = \Bitrix\Tasks\Manager\Task\Template::add($GLOBALS['USER']->getId(), [
    'TITLE' => 'Ознакомиться с записью "{{Имя записи}}"',
    'DESCRIPTION' => 'Необходимо ознакомиться с записью "[URL={{Ссылка  на запись}}]{{Имя записи}}[/URL]"'.PHP_EOL.'[URL={{Ссылка на изменения}}]Сравнение с предыдущей версией[/URL]',
    'ALLOW_CHANGE_DEADLINE' => 'Y',
    'ALLOW_TIME_TRACKING' => 'Y',
    'TASK_CONTROL' => 'Y',
    'GROUP_ID' => 0,
    'CREATED_BY' => $GLOBALS['USER']->getId(),
    'SE_RESPONSIBLE' => $responsibles,
    'SITE_ID' => 's1',
    'XML_ID' => 'WIKIEXT'
]);

echo "<pre>", var_dump($result['DATA'], $result['ERRORS']->getMessages()), "</pre>";
