<?php
use Realty\DataManager\PublicpageTable;
use Realty\DataManager\UserPublicpageTable;

$deletedUsers = [];
$obPublicpages = PublicpageTable::query()
    ->addselect('ID')
    ->addSelect('CREATED_BY')
    ->addOrder('ID')
    ->exec();

while ($publicpage = $obPublicpages->fetch()) {
    $userPublicpage = UserPublicpageTable::query()
        ->addFilter('=USER_ID', (int) $publicpage['CREATED_BY'])
        ->addFilter('=PUBLICPAGE_ID', (int) $publicpage['ID'])
        ->setLimit(1)
        ->exec()
        ->fetch();

    $success = false;
    if (empty($userPublicpage)) {
        try {
            $result = UserPublicpageTable::add([
                'PUBLICPAGE_ID' => (int) $publicpage['ID'],
                'USER_ID' => (int) $publicpage['CREATED_BY'],
                'CONFIRMED' => true,
            ]);

            $success = $result->isSuccess();
        } catch (Bitrix\Main\DB\SqlQueryException $e) {
            $deletedUsers[] = $publicpage['CREATED_BY'];
        }
    }

    if ($success) {
        printf("%d\n", (int) $publicpage['ID']);
    }
}

printf("Deleted users\n");
var_dump($deletedUsers);
