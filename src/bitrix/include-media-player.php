<?php

$fileId = '{Audio file id}';

$rows = \CFile::GetList([], ['ID' => $fileId]);
while ($row = $rows->getNext()) {
    $fileHref = \CFile::getFileSrc($row);
}

$GLOBALS['APPLICATION']->IncludeComponent(
       "bitrix:player",
       "audio_compact",
       array(
               "COMPONENT_TEMPLATE" => "audio_compact",
               "ADVANCED_MODE_SETTINGS" => "Y",
               "ALLOW_SWF" => "N",
               "AUTOSTART" => "N",
               "HEIGHT" => "20",
               "WIDTH" => "250",//"20",
               "MUTE" => "N",
               "PATH" => $fileHref,
               "TYPE" => "audio/mp3",
               "PLAYER_ID" => "bitrix_vi_record_".$fileId,
               "PLAYER_TYPE" => "flv",//"videojs",
               "PLAYLIST_SIZE" => "180",
               "PRELOAD" => "Y",
               "PREVIEW" => "",
               "REPEAT" => "none",
               "SHOW_CONTROLS" => "Y",
               "SKIN" => "audio.css",
               "SKIN_PATH" => "/bitrix/components/bitrix/voximplant.statistic.detail/player/skins",
               "USE_PLAYLIST" => "N",
               "VOLUME" => "100",
               "SIZE_TYPE" => "relative",
               "START_TIME" => "0",
               "PLAYBACK_RATE" => "1"
       ),
       false
);
