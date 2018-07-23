<?php

if (!\Bitrix\Main\Loader::includeModule('magnifico.booker')) {
    var_dump(1111111);
    return;
}

$tags = ['Nedocy', 'Xtanngrl', 'Olafonor', 'Qusern', 'Tya', 'Larikane', 'Uedanan', 'Ngo', 'Quebr', 'Zarubenas', 'Liluvisi', 'Grge', 'Jitokser', 'Cch', 'Nasanceri', 'Kkil', 'Tegann', 'Geodocime', 'Prne', 'Oritar', 'Xaberorhe', 'Dans', 'Ssmena', 'Mbril', 'Xaniawnib', 'Mirmanc', 'Rubril', 'Orlud', 'Lee', 'Asw', 'Xelovan', 'Ona', 'Wndl', 'Darantul', 'Darlunel', 'Venas', 'Ciraynar', 'Yne', 'Qust', 'Geynar', 'Rri', 'Xeey', 'Ggucors', 'Fanignn', 'Xia', 'Ricalyl', 'Ylliuma', 'Mab', 'Sorawer', 'Niell', 'Neninas', 'Wacen', 'Iewmitica', 'You', 'Mabri', 'Straza', 'Witenfion', 'Gynon', 'Cinic', 'Depanc', 'Riop', 'Ryliaran', 'Forilavi', 'Palen', 'Kaichar', 'Auatanorl', 'Fevanana', 'Wain', 'Xellisho', 'Altan', 'Rdello', 'Ydranclma', 'Men', 'Doje', 'Mandrar', 'Onntanka', 'Qurlia', 'Teim', 'Janidi', 'Teritan', 'Bana', 'Qusanene', 'Mahersli', 'Wanaiote', 'Urmki', 'Etha', 'Qun', 'Einde', 'Atell', 'Eayll', 'Baph', 'Inabel', 'Haronari', 'Vilkylis', 'Tetareelt', 'Syaru', 'Xthaadra', 'San', 'Tte', 'Dore'];

$rows = \Magnifico\Booker\ResourceTable::query()
    ->addSelect('ID')
    ->exec();

while ($row = $rows->fetch()) {
    $tagIndexes = array_rand($tags, 5);
    foreach ($tagIndexes as $index) {
        $tagRow = \Magnifico\Booker\TagTable::query()
            ->addSelect('ID')
            ->where('NAME', $tags[$index])
            ->setLimit(1)
            ->exec()
            ->fetch();

        if (0 >= (int) $tagRow['ID']) {
            $result = \Magnifico\Booker\TagTable::add(['NAME' => $tags[$index], 'CATEGORY_ID' => 7]);

            if (!$result->isSuccess()) {
                var_dump($result->getErrorMessages());
                continue;
            }

            $tagId = $result->getId();
        } else {
            $tagId = (int) $tagRow['ID'];
        }

        $result = \Magnifico\Booker\ResourceTagTable::add(['RESOURCE_ID' => $row['ID'], 'TAG_ID' => $tagId]);
        if (!$result->isSuccess()) {
            var_dump($result->getErrorMessages());
        }
    }
}

var_dump('Final');
