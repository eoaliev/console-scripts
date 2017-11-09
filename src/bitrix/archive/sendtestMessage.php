<?php
$to = 'r1@bizprofi.ru';

$subject = 'Test';

$body = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    </head>
    <body style="
        background: #E0F2F1;
        padding: 50px;
        font-size: 16px;
        line-height: 1.55em;
        font-family: Helvetica Neue,Helvetica,Arial;
        color: #444444;
    ">
        <style>
            a { color: #1976D2; }
            a:hover, a:focus { color: #0D47A1; }
        </style>

        <table width="100%" cellpadding="0" cellspacing="0" border="0">
            <tbody>
                <tr>
                    <td align="center">
                        <table width="600" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
                            <tbody>
                                <tr>
                                    <td colspan="3" height="50"></td>
                                </tr>
                                <tr>
                                    <td width="50"></td>
                                    <td>
                                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                            <tbody>
                                                <tr>
                                                    <td width="192">
                                                        <a href="https://realtylocal.ru/?utm_source=emailshapka&amp;utm_medium=email&amp;utm_campaign=perehodsshapkipisma" title="Перейти на сайт RegionalRealty.ru">
                                                            <img alt="Сайт недвижимости RegionalRealty.ru" src="https://realtylocal.ru/local/assets/images/notifier-logo.jpg" />
                                                        </a>
                                                    </td>
                                                    <td align="right">
                                                        <a href="https://realtylocal.ru/?utm_source=emailshapka&amp;utm_medium=email&amp;utm_campaign=perehodsshapkipisma" title="Перейти на сайт RegionalRealty.ru">Перейти на сайт RegionalRealty.ru</a>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                    <td width="50"></td>
                                </tr>
                                <tr>
                                    <td colspan="3" height="50"></td>
                                </tr>
                                <tr>
                                    <td width="50"></td>
                                    <td>test</td>
                                    <td width="50"></td>
                                </tr>
                                <tr>
                                    <td colspan="3" height="50" style="border-width: 1px 0 0 0; border-style: solid; border-color: #ECEFF1;"></td>
                                </tr>
                                <tr>
                                    <td width="50"></td>
                                    <td style="color: #B0BEC5; font-size: 13px; line-height: 1.5em;">
                                        © 2015  <a href="https://realtylocal.ru/?utm_source=emailshapka&amp;utm_medium=email&amp;utm_campaign=perehodsshapkipisma">RegionalRealty.ru</a>
                                    </td>
                                    <td width="50"></td>
                                </tr>
                                <tr>
                                    <td colspan="3" height="10"></td>
                                </tr>
                                <tr>
                                    <td width="50"></td>
                                    <td style="color: #B0BEC5; font-size: 13px; line-height: 1.5em;">
                                        Вы получаете эту рассылку, потому что являетесь зарегистрированным пользователем сайта. Если вы не хотите узнавать самые свежие новости проекта и получать информацию о крайне выгодных акциях, пожалуйста, 
                                        <a href="https://realtylocal.ru/notifications/unsubscribe/?uuid=uuid">нажмите на эту ссылку</a>
                                    </td>
                                    <td width="50"></td>
                                </tr>
                                <tr>
                                    <td colspan="3" height="50"></td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
            </tbody>
        </table>
    </body>
</html>';

$header = [
    "From" => "RegionalRealty.ru <noreply@regionalrealty.ru>",
    "Reply-To" => "noreply@regionalrealty.ru",
    "List-Unsubscribe" => "<https://regionalrealty.ru/notifications/unsubscribe/?uuind=uuid>",
    "X-EVENT_NAME" => "OUTSIZE_ADD_REQUEST",
];

$charset = 'ru';

$contentType = 'html';

$messageId = '';

$attachment = null;

$trackRead = null;

$trackClick = null;

$result = Main\Mail\Mail::send(array(
    'TO' => $to,
    'SUBJECT' => $subject,
    'BODY' => $body,
    'HEADER' => $header,
    'CHARSET' => $charset,
    'CONTENT_TYPE' => $content_type,
    'MESSAGE_ID' => $messageId,
    'ATTACHMENT' => $attachment,
    'TRACK_READ' => $trackRead,
    'TRACK_CLICK' => $trackClick
));
