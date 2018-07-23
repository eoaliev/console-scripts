<?php

\Bitrix\Main\Loader::includeModule('crm');

$rows = \CCrmEvent::GetList(['DATE_CREATE' => 'ASC'], ['EVENT_TYPE' => \CCrmEvent::TYPE_DELETE, '>=DATE_CREATE' => (new \Bitrix\Main\Type\Datetime())->setTime(0, 0, 0)]);

$csv = [];
while ($row = $rows->fetch()) {
    $row['CREATED'] = implode(' ', array_filter([$row['CREATED_BY_NAME'], $row['CREATED_BY_LAST_NAME'], $row['CREATED_BY_SECOND_NAME']]));

    foreach (['ID', 'ENTITY_TYPE', 'ENTITY_ID', 'ENTITY_FIELD', 'EVENT_ID', 'EVENT_TYPE', 'EVENT_TEXT_2', 'FILES', 'CREATED_BY_ID', 'CREATED_BY_LOGIN', 'CREATED_BY_NAME', 'CREATED_BY_LAST_NAME', 'CREATED_BY_SECOND_NAME'] as $key) {
        unset($row[$key]);
    }


    if (0 >= count($csv)) {
        $csv[] = implode(';', array_keys($row));
    }

    $csv[] = implode(';', array_values($row));
}

echo implode(PHP_EOL, $csv);
