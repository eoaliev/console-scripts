<?php

use Bitrix\Main\Type;
use Magnifico\Booker\PrintedEditionTable;
use Magnifico\Booker\ReservationStageTable;
use Magnifico\Booker\ReservationTable;
use Magnifico\Booker\ResourceTable;

$rows = ResourceTable::query()
    ->addSelect('ID')
    ->exec();

$resourceIds = [];
while ($row = $rows->fetch()) {
    $resourceIds[] = (int) $row['ID'];
}

$userIds = [];
foreach (\Bitrix\Intranet\Util::getEmployeesList(['SITE_ID' => 's1']) as $user) {
    $userIds[] = (int) $user['ID'];
}

for ($i = 0; $i < 1000; $i++) {
    $result = PrintedEditionTable::add([
        'ISBN' => randomString(12),
        'RESOURCE_ID' => $resourceIds[array_rand($resourceIds)],
        'AMOUNT' => 1,
    ]);
    if (!$result->isSuccess()) {
        echo implode(PHP_EOL, $result->getErrorMessages()).PHP_EOL;
        continue;
    }

    $printedEditionId = $result->getId();
    for ($j = 0; $j < 5; $j++) {
        $userId = $userIds[array_rand($userIds)];

        $result = ReservationTable::add([
            'PRINTED_EDITION_ID' => $printedEditionId,
            'CREATED_BY' => $userId,
        ]);
        if (!$result->isSuccess()) {
            echo implode(PHP_EOL, $result->getErrorMessages()).PHP_EOL;
            continue;
        }

        $reservationId = $result->getId();

        $from = new Type\Date(
            sprintf(
                "2018.%'.02d.%'.02d",
                rand((int) (new Type\Date())->format('m') + 1, 12),
                rand(1, 30)
            ),
            'Y.m.d'
        );

        $to = (new Type\Date($from))->add('14D');

        $result = ReservationStageTable::add([
            'RESERVATION_ID' => $reservationId,
            'CREATED_BY' => $userId,
            'STAGE' => ReservationStageTable::STAGE_GET,
            'STATUS' => ReservationStageTable::STATUS_WAIT,
            'FROM' => $from,
            'TO' => $to,
            'TEXT' => 'Добавлен новый запрос на выдачу книги',
        ]);
        if (!$result->isSuccess()) {
            echo implode(PHP_EOL, $result->getErrorMessages()).PHP_EOL;
            continue;
        }
    }
}
