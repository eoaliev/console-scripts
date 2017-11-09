<?php

use Bitrix\Main\Web;

$token = '---';
$counterId = '---';

$url = 'https://api-metrika.yandex.ru/management/v1/counter/'.$counterId.'/logrequests';

// $query = http_build_query([
//     'date1' => '2017-09-09',
//     'date2' => '2017-09-10',
//     'fields' => 'ym:s:clientID,ym:s:lastTrafficSource,ym:s:lastReferalSource',
//     'source' => 'visits',
//     'oauth_token' => $token,
// ]);


$httpClient = new Web\HttpClient();

// $response = json_decode($httpClient->get($url.'/evaluate?'.$query, []), true);
// if ($response['log_request_evaluation']['possible'] !== true) {
//     var_dump('Not evaluate log request.');
//     return;
// }

// $response = json_decode($httpClient->post($url.'?'.$query, []), true);
// if (!$response['log_request']) {
//     var_dump('Fail create log request.');
//     return;
// }

// $logRequest = $response['log_request'];
// if ($logRequest['status'] !== 'created') {
//     var_dump('Process...');
//     return;
// }

$response = json_decode($httpClient->get($url.'?oauth_token='.$token, []), true);

echo '<pre>', var_dump($response), '</pre>';
// $response = $httpClient->get($url.'/'.$logRequest['request_id'].'/part/0/download?oauth_token='.$token, []);

// echo '<pre>', var_dump($logRequest['request_id'], $url.'/'.$logRequest['request_id'].'/part/0/download?oauth_token='.$token, $response), '</pre>';

