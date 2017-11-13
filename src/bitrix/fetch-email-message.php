<?php

use Bitrix\Main\Loader;
use Bitrix\Main\Type;
use Bitrix\Mail;

Loader::includeModule('intranet');
Loader::includeModule('mail');

$mailbox = Mail\MailboxTable::getList(array(
    'filter' => array(
        '=ACTIVE'      => 'Y',
        '=USER_ID'     => 12,
        '@SERVER_TYPE' => array('imap', 'controller', 'domain', 'crdomain'),
    ),
    'order' => array('ID' => 'DESC'),
))->fetch();
if (empty($mailbox)) {
    var_dump('empty mail box');
    return;
}

$mailbox['OPTIONS']['sync_from'] = (new Type\DateTime('20-07-2017 00:00', 'd-m-Y H:i'))->getTimestamp();

$result = Mail\MailboxTable::update($mailbox['ID'], ['OPTIONS' => $mailbox['OPTIONS']]);
if (!$result->isSuccess()) {
    var_dump($result->getErrorMessages());
    return;
}

$result = Mail\Helper::syncMailbox($mailbox['ID'], $error);
var_dump($result, $error);
