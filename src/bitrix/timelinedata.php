<?php

$times = [
    ["07:38:06", "07:38:06"],
    ["07:38:33", "09:02:17"],
    ["09:05:16", "09:39:52"],
    ["09:43:52", "09:48:27"],
    ["09:44:51", "09:48:51"],
    ["09:49:22", "10:32:04"],
    ["10:35:07", "10:59:15"],
    ["11:02:23", "11:05:36"],
    ["11:06:17", "11:52:24"],
    ["13:08:38", "13:08:59"],
    ["13:08:59", "13:11:57"],
    ["13:12:02", "13:23:03"],
    ["13:23:07", "13:27:03"],
    ["13:26:45", "13:41:45"],
    ["13:41:40", "14:39:25"],
    ["14:40:23", "14:43:59"],
    ["14:44:05", "15:14:21"],
    ["15:14:27", "15:20:05"],
    ["15:20:28", "15:21:42"],
    ["15:22:19", "15:52:29"],
    ["15:54:20", "15:57:51"],
    ["15:58:19", "16:27:41"],
    ["16:29:44", "16:39:44"],
    ["16:45:07", "16:49:22"],
    ["16:55:10", "16:58:44"],
    ["16:58:44", "16:59:27"],
    ["17:01:47", "17:17:38"],
    ["17:19:46", "17:19:46"],
];

$prev = 0;
$diff = 0;
$coordinates = [];
foreach ($times as $interval) {
    list($hour, $minute, $seconds) = explode(':', $interval[0]);
    $start = \Bitrix\Main\Type\Datetime::createFromTimestamp(0)->setTime($hour, $minute, $seconds);

    list($hour, $minute, $seconds) = explode(':', $interval[1]);
    $final = \Bitrix\Main\Type\Datetime::createFromTimestamp(0)->setTime($hour, $minute, $seconds);

    $segment = ceil(($start->getTimestamp() - $prev) / 60);
    if (0 < $diff && $segment < 0) {
        for ($i = $diff; $i < $diff + $segment; $i++) {
            $coordinates[] = [$i, 0];
        }

        $diff += $segment;
    }

    $sign = 1;
    $segment = ceil(($final->getTimestamp() - $start->getTimestamp()) / 60);
    for ($i = $diff; $i < $diff + $segment; $i++) {
        $coordinates[] = [$i, $sign * 1];
        $sign *= -1;
    }
    
    $diff += $segment;
    $prev = $final->getTimestamp();
}

$coordinates = array_map(function ($coordinate) {
    return implode(';', $coordinate);
}, $coordinates);

var_dump(implode(PHP_EOL, $coordinates));