<?php

require_once($_SERVER["DOCUMENT_ROOT"]."/bitrix/modules/main/classes/general/backup.php");

$strVal = randString(16);

$temporary_cache = $strVal ? mcrypt_encrypt(MCRYPT_BLOWFISH, CPasswordStorage::getEncryptKey(), CPasswordStorage::SIGN.$strVal, MCRYPT_MODE_ECB, pack("a8",CPasswordStorage::getEncryptKey())) : '';
COption::SetOptionString('main', 'backup_secret_key', base64_encode($temporary_cache));
var_dump($strVal, CPasswordStorage::get('backup_secret_key'));