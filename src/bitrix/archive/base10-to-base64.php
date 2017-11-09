<?php

$id = 254354;

$abc = '0123456789ABCDEFGHIJKLNMOPQRSTUVWXYZabcdefghijklnmopqrstuvwxyz';

$code = '';
$quotient = $id;
do {
    $remainder = $quotient % strlen($abc);
    $quotient = floor($quotient / strlen($abc));
    $code .= $abc[$remainder];
} while ($quotient > 0);

$code = strrev($code);

var_dump($code);