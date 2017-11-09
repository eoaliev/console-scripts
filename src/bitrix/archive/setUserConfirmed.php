<?php
use Realty\DataManager\UserTable;
use Rhumsaa\Uuid\Uuid;

$successCount = $errorsCount = $skippedCount = 0;
$lastId = 0;

while (true) {
    $rows = UserTable::query()
        ->addFilter('>ID', $lastId)
        ->addSelect('ID')
        ->addSelect('UF_CONFIRM_UUID')
        ->addSelect('UF_CONFIRMED')
        ->addOrder('ID', 'ASC')
        ->setLimit(1000)
        ->exec();

    if ($rows->getSelectedRowsCount() <= 0) {
        break;
    }

    while ($row = $rows->fetch()) {
        $lastId = $row['ID'];

        $fields = array();
        if ($row['UF_CONFIRMED'] !== true) {
            $fields['UF_CONFIRMED'] = true;
        } 

        if (empty($row['UF_CONFIRM_UUID'])) {
            $uniqid = Uuid::uuid4()->toString();
            $fields['UF_CONFIRM_UUID'] = $uniqid;
        }

        if (empty($fields)) {
            $skippedCount++;
            continue;
        }

        $result = UserTable::update($row['ID'], $fields);
        if ($result->isSuccess()) {
            $successCount++;
        } else {
            $errorsCount++;
        }
    }
}

var_dump($successCount, $errorsCount, $skippedCount);