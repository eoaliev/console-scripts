<?php

require_once($_SERVER["DOCUMENT_ROOT"]."/bitrix/header.php");

\CJSCore::init(['jquery']);

$request = \Bitrix\Main\Application::getInstance()->getContext()->getRequest();

if ($request->isPost()) {
    header('Content-Type: application/json; charset=utf-8');
    $GLOBALS['APPLICATION']->restartBuffer();

    if ($method === 'import') {
        if ((float) $request->get('version') >= 2.10) {
            $lastIndex = (int) $request->get('last_index') ?: 0;
            if (!($step = $request->get('step')) || $step = 'catalog') {
                if ($lastIndex === 0) {
                    shell_exec('cp -R '.$_SERVER["DOCUMENT_ROOT"].$request->get('folder').' '.$_SERVER["DOCUMENT_ROOT"].'/upload/1c_catalog/');
                }

                if (!($items = preg_grep('/^import_/', scandir($_SERVER["DOCUMENT_ROOT"].$request->get('folder').'/000000002/')))) {
                    echo \Bitrix\Main\Web\Json::encode(array(
                        'status' => 'fail',
                        'messages' => ['Нет файлов в переданной папке'],
                    ), JSON_UNESCAPED_SLASHES|JSON_UNESCAPED_UNICODE);

                    $GLOBALS['APPLICATION']->finalActions();
                    die();
                }

                array_splice($items, 0, $lastIndex);

                foreach ($items as $index => $filename) {
                    echo \Bitrix\Main\Web\Json::encode(array(
                        'status' => 'success',
                        'data' => array(
                            'filename' => str_replace('/upload/', '', $request->get('folder')).'/000000002/'.$filename,
                            'step' => 'catalog',
                            'last_index' => $index,
                        ),
                    ), JSON_UNESCAPED_SLASHES|JSON_UNESCAPED_UNICODE);

                    $GLOBALS['APPLICATION']->finalActions();
                    die();
                }

                $step = 'goods';
                $lastIndex = 0;
            }

            if ($step === 'goods') {
                $items = array_filter(array_unique(array_map('intval', preg_grep('/^\d+$/', scandir($_SERVER["DOCUMENT_ROOT"].$request->get('folder').'/000000002/goods/')))));
                if ($lastIndex <= max($items)) {
                    $items = preg_grep('/\.xml$/', scandir($_SERVER["DOCUMENT_ROOT"].$request->get('folder').'/000000002/goods/'.$lastIndex.'/'));

                    array_splice($items, 0, (int) $request->get('g_last_index'));

                    foreach ($items as $index => $filename) {
                        echo \Bitrix\Main\Web\Json::encode(array(
                            'status' => 'success',
                            'data' => array(
                                'filename' => str_replace('/upload/', '', $request->get('folder')).'/000000002/goods/'.$lastIndex.'/'.$filename,
                                'step' => 'goods',
                                'last_index' => $lastIndex,
                                'g_last_index' => $index
                            ),
                        ), JSON_UNESCAPED_SLASHES|JSON_UNESCAPED_UNICODE);

                        $GLOBALS['APPLICATION']->finalActions();
                        die();
                    }
                }

                $step = 'properties';
                $lastIndex = 0;
            }

            if ($step === 'properties') {
                $items = array_filter(array_unique(array_map('intval', preg_grep('/^\d+$/', scandir($_SERVER["DOCUMENT_ROOT"].$request->get('folder').'/000000002/properties/')))));
                if ($lastIndex <= max($items)) {
                    $items = preg_grep('/\.xml$/', scandir($_SERVER["DOCUMENT_ROOT"].$request->get('folder').'/000000002/properties/'.$lastIndex.'/'));

                    array_splice($items, 0, (int) $request->get('p_last_index'));

                    foreach ($items as $index => $filename) {
                        echo \Bitrix\Main\Web\Json::encode(array(
                            'status' => 'success',
                            'data' => array(
                                'filename' => str_replace('/upload/', '', $request->get('folder')).'/000000002/properties/'.$lastIndex.'/'.$filename,
                                'step' => 'properties',
                                'last_index' => $lastIndex,
                                'p_last_index' => $index,
                            ),
                        ), JSON_UNESCAPED_SLASHES|JSON_UNESCAPED_UNICODE);

                        $GLOBALS['APPLICATION']->finalActions();
                        die();
                    }
                }
            }
        }
    }

    echo \Bitrix\Main\Web\Json::encode([
        'status' => 'final',
    ], JSON_UNESCAPED_SLASHES|JSON_UNESCAPED_UNICODE);

    $GLOBALS['APPLICATION']->finalActions();
    die();
}
?>
<form action="<?=POST_FORM_ACTION_URI?>" method="POST" class="initiator">
    <div>
        <label>Версия обмена</label>
        <input type="text" name="version" value="<?=$request->get('version')?>" />
    </div>
    <div>
        <label>Папка с файлами</label>
        <input type="text" name="folder" value="<?=$request->get('folder')?>" />
    </div>

    <input type="submit" name="submit" value="Начать" />
</form>
<pre class="log"></pre>
<script>
$(function () {
    var sessidName, sessidValue

    var query = function (uri, data, callback, dataType) {
        data = data || null;

        dataType = dataType || 'json'

         $.ajax({
            url: uri,
            type: 'POST',
            data: data,
            dataType: dataType,
            xhrFields: {
                withCredentials: true,
            },
        }).then(callback, function () {
            alert('Что-то пошло не так');
            console.log(arguments);
        });
    };

    var checkResponse = function (response) {
        if (typeof response !== 'object' || (response.status !== 'success' && response.status !== 'final')) {
            alert(response.messages.join("\n"));
            return false;
        }

        return true;
    };

    var importFile = function (uri, callback) {
        query(uri, null, function (data) {
            if (data.indexOf('failure') !== -1) {
                return;
            }

            if (data.indexOf('success') !== -1) {
                setTimeout(function () {
                    callback(data);
                }, 100);
                return;
            }

            $('.log').html(data);
            importFile(uri, callback);
        }, 'html');
    };

    var importQuery = function (data) {
        data = data || {};

        query($('.initiator').attr('action'), {
            version: $('.initiator').find('[name="version"]').val(),
            folder: $('.initiator').find('[name="folder"]').val(),
            method: 'import',
            step: data.step ? data.step: null,
            last_index: data.last_index ? data.last_index: null,
            g_last_index: data.g_last_index ? data.g_last_index: null,
            p_last_index: data.p_last_index ? data.p_last_index: null,
        }, function (response) {
            if (!checkResponse(response)) {
                return;
            }

            if (response.status === 'final') {
                $('.log').html('Импортированно');
                return;
            }

            var uri = '/bitrix/admin/1c_exchange.php?type=catalog&mode=import'
                 + '&version=' + $('.initiator').find('[name="version"]').val()
                 + '&filename=' + response.data.filename
                 + '&sessid=' + BX.bitrix_sessid();

            importFile(uri, function () {
                importQuery(response.data);
            });
        });
    };



    $('.initiator').on('submit', function (e) {
        e.preventDefault();
        e.stopPropagation();

        query('/bitrix/admin/1c_exchange.php?type=catalog&mode=checkauth', null, function (response) {
            $('.log').html(response);

            query('/bitrix/admin/1c_exchange.php?type=catalog&mode=init&version=' + $('.initiator').find('[name="version"]').val() + '&sessid=' + BX.bitrix_sessid(), null, function (response) {
                $('.log').html(response);

                importQuery();
            }, 'html');
        }, 'html');
    });
});
</script>
<?php
require_once($_SERVER["DOCUMENT_ROOT"]."/bitrix/footer.php");
