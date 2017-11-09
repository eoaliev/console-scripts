<?php

use Bitrix\Main\Loader;
use Bitrix\Main\Application;

if (!Loader::includeModule('mail')) {
    return;
}

$connection = Application::getInstance()->getConnection();

$messageRow = $connection->query('SELECT * FROM `b_mail_message` WHERE `ID`=3')->fetch();
$actRow = $connection->query('SELECT * FROM `b_crm_act` where `ID`=2768')->fetch();

$html = ltrim(str_replace($messageRow['HEADER'], '', $messageRow['FOR_SPAM_TEST']));
$msg = preg_replace('/<script[^>]*>.*?<\/script>/is', '', $html);
$msg = preg_replace('/<title[^>]*>.*?<\/title>/is', '', $msg);

$sanitizer = new \CBXSanitizer();
$sanitizer->setLevel(\CBXSanitizer::SECURE_LEVEL_LOW);
$sanitizer->applyHtmlSpecChars(false);
$sanitizer->addTags(array('style' => array()));
$html = $sanitizer->sanitizeHtml($msg);

var_dump($html, $actRow['DESCRIPTION'], md5($html), md5($actRow['DESCRIPTION']), md5($html) === md5($actRow['DESCRIPTION']));