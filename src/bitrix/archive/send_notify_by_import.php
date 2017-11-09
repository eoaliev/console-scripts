<?php
use Realty\DataManager\ImportTable;
use Realty\AppKernel;

$container = AppKernel::getInstance()->getContainer();
$notifier = $container->get('notifier');

$body = '<h1>Добрый день.</h1>
<br />
<p>Коллеги, ваши объявления выгружаются на нашу площадку RegionalRealty.ru. Мы обновили формат выгрузки на Яндекс.Недвижимость и в ближайшее время будем ретранслировать ваши объявления туда.</p>
<br />
<p>Если вы не хотите, чтобы мы выгружали ваши объявления в общем фиде на Яндекс.Недвижимость, напишите на support@regionalrealty.ru письмо с тем, чтобы мы не выгружали ваши объявления на сервис Яндекса.</p>
<br />
<br />
<p>Если вы не напишете нам ответное письмо в течение двух дней, мы будем ретранслировать (выгружать) ваши объекты на Яндекс.Недвижимость. Однако вы в любой момент можете остановить ретрансляцию, просто написав нам.</p>
<br />
<br />
<p>Если у вас есть вопросы, просто напишите или позвоните нам: </p>
<p>E-mail: info@regionalrealty.ru</p>
<p>Тел: +7 (499)350-35-18</p>';

$subject = 'Ретрансляция объявлений с RegionalRealty.ru на Яндекс.Недвижимость';

$rows = ImportTable::query()
    ->addFilter('=STATUS', ImportTable::STATUS_ACTIVE)
    ->addFilter('=NOT_EXPORT', false)
    ->addGroup('CONTACT_EMAIL')
    ->addSelect('CONTACT_EMAIL')
    ->exec();

var_dump($rows->getSelectedRowsCount());
while ($row = $rows->fetch()) {
    $notifier->send('mailing_list', $row['CONTACT_EMAIL'], [
        'body' => $body,
        'subject' => $subject,
    ]);

    printf("Message send %s.\n", $row['CONTACT_EMAIL']);
}
