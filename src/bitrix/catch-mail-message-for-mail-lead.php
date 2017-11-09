<?php

use Bitrix\Main\Application;

$connection = Application::getInstance()->getConnection();

$leadRow = $connection->query('SELECT * FROM `b_crm_lead` WHERE `ID`=918')->fetch();
$messageRow = $connection->query('SELECT * FROM `b_mail_message` WHERE `ID`=7232')->fetch();
$actRow = $connection->query('SELECT * FROM `b_crm_act` where `ID`=2768')->fetch();

$comment = $leadRow['COMMENTS'];
$leadHash = md5($comment);

$description = $actRow['DESCRIPTION'];
$actHash = md5($description);

$body = preg_replace("/(\r\n|\n|\r)+/", '<br/>', htmlspecialcharsbx($messageRow['BODY']));
$messageHash = md5($body);

var_dump(
	$comment, 
	$body, 
	$description, 
	$leadHash, 
	$messageHash, 
	$actHash, 
	$leadHash === $messageHash,
	$leadHash === $actHash,
	$actHash === $messageHash
);
