<?php

$GLOBALS['DB']->StartTransaction();

$entity = new \CEventType();

$typeId = $entity->add([
    'LID' => 'ru',
    'EVENT_NAME' => 'AFTER_USER_REGISTER',
    'NAME' => 'Успешная регистрация пользователя',
    'DESCRIPTION' => implode("\n", [
        '#USER_ID# - ID пользователя',
        '#STATUS# - Статус логина',
        '#MESSAGE# - Сообщение пользователю',
        '#LOGIN# - Логин',
        '#URL_LOGIN# - Логин, закодированный для использования в URL',
        '#CHECKWORD# - Контрольная строка для смены пароля',
        '#NAME# - Имя',
        '#LAST_NAME# - Фамилия',
        '#EMAIL# - E-Mail пользователя',
        '#PASSWORD# - Пароль пользователя',
    ]),
]);

if ((int) $typeId <= 0) {
    throw new \Exception($entity->LAST_ERROR, 1);
}

$lids = [];

$params = ['filter' => ['=ACTIVE' => 'Y'], 'select' => ['LID'], 'order' => ['SORT' => 'ASC']];

$rows = \Bitrix\Main\SiteTable::GetList($params);
while ($row = $rows->fetch()) {
    $lids[] = $row['LID'];
}

$html = <<<MESSAGE
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ru" lang="ru">
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=windows-1251"/>
    <style>
        body
        {
            font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
            font-size: 14px;
            color: #000;
        }
    </style>
</head>
<body>
<table cellpadding="0" cellspacing="0" width="850" style="background-color: #d1d1d1; border-radius: 2px; border:1px solid #d1d1d1; margin: 0 auto;" border="1" bordercolor="#d1d1d1">
    <tr>
        <td height="83" width="850" bgcolor="#eaf3f5" style="border: none; padding-top: 23px; padding-right: 17px; padding-bottom: 24px; padding-left: 17px;">
            <table cellpadding="0" cellspacing="0" border="0" width="100%">
                <tr>
                    <td bgcolor="#ffffff" height="75" style="font-weight: bold; text-align: center; font-size: 26px; color: #0b3961;">#SITE_NAME#: Регистрационная информация</td>
                </tr>
                <tr>
                    <td bgcolor="#bad3df" height="11"></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td width="850" bgcolor="#f7f7f7" valign="top" style="border: none; padding-top: 0; padding-right: 44px; padding-bottom: 16px; padding-left: 44px;">
            <p style="margin-top:30px; margin-bottom: 28px; font-weight: bold; font-size: 19px;"></p>
            <p style="margin-top: 0; margin-bottom: 20px; line-height: 20px;">
Информационное сообщение сайта #SITE_NAME#<br />
------------------------------------------<br />
#NAME# #LAST_NAME#<br />
<br />
#MESSAGE#<br />
<br />
Ваша регистрационная информация:<br />
<br />
ID пользователя: #USER_ID#<br />
Статус профиля: #STATUS#<br />
Login: #LOGIN#<br />
Password: #PASSWORD#<br />
<br />
Вы можете изменить пароль, перейдя по <a href="http://#SERVER_NAME#/auth/index.php?change_password=yes&lang=ru&USER_CHECKWORD=#CHECKWORD#&USER_LOGIN=#URL_LOGIN#">ссылке</a>
<br />
Сообщение сгенерировано автоматически.<br />
</p>
        </td>
    </tr>
    <tr>
        <td height="40px" width="850" bgcolor="#f7f7f7" valign="top" style="border: none; padding-top: 0; padding-right: 44px; padding-bottom: 30px; padding-left: 44px;">
            <p style="border-top: 1px solid #d1d1d1; margin-bottom: 5px; margin-top: 0; padding-top: 20px; line-height:21px;">С уважением,<br />администрация сайта <a href="http://#SERVER_NAME#" style="color:#2e6eb6;">#SITE_NAME#</a>
            </p>
        </td>
    </tr>
</table>
</body>
</html>
MESSAGE;

$message["ACTIVE"] = "Y";
$message["EVENT_NAME"] = "AFTER_USER_REGISTER";
$message["LID"] = $lids;
$message["EMAIL_TO"] = "#EMAIL#";
$message["EMAIL_FROM"] = "#DEFAULT_EMAIL_FROM#";
$message["SUBJECT"] = "#SITE_NAME#: Регистрационная информация";
$message["BODY_TYPE"] = "html";
$message["MESSAGE"] = $html;

$emess = new \CEventMessage();
$messageId = $emess->Add($message);

if ((int) $messageId <= 0) {
    throw new \Exception($entity->LAST_ERROR, 1);
}

$GLOBALS['DB']->Commit();
