<?php

use Bitrix\Main\Config;

Config\Option::set('magnifico.site', 'catalog_iblock_id', 60);
Config\Option::set('magnifico.site', 'sale_xml_id', '0ab1c635-c669-11e5-a8e5-002590812cbd');
Config\Option::set('magnifico.site', 'submenu_icon_map', json_encode([
    'b9dfc967-bf2b-11e4-af70-cc5a3f2d84bd' => 'icon-menu1', // ���������� ������
    'b9dfc963-bf2b-11e4-af70-cc5a3f2d84bd' => 'icon-menu2', // ������������
    '2ba5e033-1393-11e7-860d-002590812cbd' => 'icon-menu3', // �������
    'b9dfc968-bf2b-11e4-af70-cc5a3f2d84bd' => 'icon-menu4', // ������ ��� ������� � ���������
    'f6a5b9b0-2bf3-11e7-a6ed-002590812cbd' => 'icon-menu5', // ��� � ������
    'b9dfc964-bf2b-11e4-af70-cc5a3f2d84bd' => 'icon-menu6', // ������ ��� ����
    'f36a5839-dbb8-11e5-9397-002590812cbd' => 'icon-menu7', // �������� � ����������
    'e2223962-db5d-11e4-84c4-002590812cbd' => 'icon-menu8', // ������ ��� ������
    '0ab1c635-c669-11e5-a8e5-002590812cbd' => 'icon-menu9', // ����������
], JSON_UNESCAPED_SLASHES|JSON_UNESCAPED_UNICODE));
Config\Option::set('magnifico.site', 'bottommenu_icon_map', json_encode([
    '/catalog/' => 'icon-menub1', // �������
    '/search/' => 'icon-search', // �����
    '/personal/favorite/' => 'icon-heart', // ���������
    '/personal/profile/' => 'icon-user', // �������
    '/auth/' => 'icon-user', // ��������������
    '/personal/cart/' => 'icon-cart', // �������
], JSON_UNESCAPED_SLASHES|JSON_UNESCAPED_UNICODE));

