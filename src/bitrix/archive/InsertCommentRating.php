<?php

use Bitrix\Main\Type\Datetime;
use Ramsey\Uuid\Uuid;
use Realty\DataManager\CommentRatingTable;
use Realty\DataManager\CommentTable;
use Realty\Service\UpsertQueue;

$upsertQueue = new UpsertQueue(CommentRatingTable::getEntity());

$rows = CommentTable::query()
    ->addFilter(0, [
        'LOGIC' => 'OR',
        ['>POSITIVE_COUNT' => 0],
        ['>NEGATIVE_COUNT' => 0],
    ])
    ->addSelect('ID')
    ->addSelect('POSITIVE_COUNT')
    ->addSelect('NEGATIVE_COUNT')
    ->addOrder('ID', 'ASC')
    ->exec();

printf('Select %s comment rows for insert comment rating'."\n", $rows->getSelectedRowsCount());

while ($row = $rows->fetch()) {
    if ($row['POSITIVE_COUNT'] > 0) {
        for ($i = 0; $i < $row['POSITIVE_COUNT']; $i++) {
            $upsertQueue->push([
                'COMMENT_ID' => $row['ID'],
                'VISITOR_ID' => (string) Uuid::uuid4(),
                'LIKE' => true,
                'DATE' => new Datetime(),
            ]);
        }

        printf('Push %s positive comment rating'."\n", $row['POSITIVE_COUNT']);
    }

    if ($row['NEGATIVE_COUNT'] > 0) {
        for ($i = 0; $i < $row['NEGATIVE_COUNT']; $i++) {
            $upsertQueue->push([
                'COMMENT_ID' => $row['ID'],
                'VISITOR_ID' => (string) Uuid::uuid4(),
                'LIKE' => false,
                'DATE' => new Datetime(),
            ]);
        }

        printf('Push %s negative comment rating'."\n", $row['NEGATIVE_COUNT']);
    }

    if (count($upsertQueue) > 1000) {
        printf('Flush %s comment rating'."\n", count($upsertQueue));
        $upsertQueue->flush();
    }
}

if (count($upsertQueue)) {
    printf('Flush %s comment rating'."\n", count($upsertQueue));
    $upsertQueue->flush();
}

printf('End process');
