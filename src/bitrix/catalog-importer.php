<?php

define('BX_SESSION_ID_CHANGE', false);
define('BX_SKIP_POST_UNQUOTE', true);
define('NO_AGENT_CHECK', true);
define("STATISTIC_SKIP_ACTIVITY_CHECK", true);

require_once($_SERVER["DOCUMENT_ROOT"]."/bitrix/modules/main/include/prolog_before.php");

$request = \Bitrix\Main\Application::getInstance()->getContext()->getRequest();

class MagnificoCatalogImporterPostController {
    /**
     * @var \Bitrix\Main\HttpRequest|null
     */
    protected $request = null;

    public function __construct()
    {
        $this->request = \Bitrix\Main\Application::getInstance()->getContext()->getRequest();
    }

    public function __invoke()
    {
        if (!$this->request->isPost()) {
            return;
        }

        $this->header();

        $this->process();

        $this->footer();
        die();
    }

    protected function header()
    {
        header('Content-Type: application/json; charset=utf-8');
        $GLOBALS['APPLICATION']->restartBuffer();
    }

    protected function footer()
    {
        $GLOBALS['APPLICATION']->finalActions();
    }

    protected function output($data)
    {
        echo \Bitrix\Main\Web\Json::encode($data, JSON_UNESCAPED_SLASHES|JSON_UNESCAPED_UNICODE);
    }

    protected function success($data = array())
    {
        $this->output(array(
            'status' => 'success',
            'data' => $data ?: null,
        ));
    }

    protected function fail($message)
    {
        $this->output(array(
            'status' => 'fail',
            'messages' => array($message),
        ));
    }

    protected function process()
    {
        if ($this->request->get('method') === 'import') {
            return $this->import();
        }

        if ($this->request->get('method') === 'cp') {
            return $this->cp($this->request->get('filepath'), true);
        }

        return $this->output(array('status' => 'final'));
    }

    protected function import()
    {
        if (2.10 > (float) $this->request->get('version')) {
            return $this->output(array('status' => 'final'));
        }

        if (!($step = $this->request->get('step')) || $step = 'catalog') {
            return $this->importCatalog($this->request->get('folder'), $this->request->get('current_index'));
        }

        if ($step === 'goods') {
            return $this->importGoods($this->request->get('folder'), $this->request->get('current_index'), $this->request->get('sub_current_index'));
        }

        if ($step === 'properties') {
            return $this->importProperties($this->request->get('folder'), $this->request->get('current_index'), $this->request->get('sub_current_index'));
        }

        return $this->output(array('status' => 'final'));
    }

    protected function importCatalog($folder, $currentIndex = 0)
    {
        if (!($items = preg_grep('/^import_/', scandir($_SERVER["DOCUMENT_ROOT"].$folder.'/000000002/')))) {
            return $this->fail('Нет файлов в переданной папке');
        }

        array_splice($items, 0, $currentIndex);

        foreach ($items as $index => $filename) {
            $this->cp(str_replace('/upload/', '', $folder).'/000000002/'.$filename);

            return $this->success(array(
                'filename' => str_replace('/upload/', '', $folder).'/000000002/'.$filename,
                'step' => 'catalog',
                'last_index' => $index,
            ));
        }

        return $this->importGoods($folder);
    }

    protected function importGoods($folder, $currentIndex = 0, $subCurrentIndex = 0)
    {
        $items = array_values(array_filter(array_unique(array_map('intval', preg_grep('/^\d+$/', scandir($_SERVER["DOCUMENT_ROOT"].$folder.'/000000002/goods/'))))));
        if (max(array_keys($items)) < (int) $currentIndex) {
            return $this->importProperties($folder);
        }

        $subFolder = $items[$currentIndex];
        if (!($items = preg_grep('/\.xml$/', scandir($_SERVER["DOCUMENT_ROOT"].$folder.'/000000002/goods/'.$subFolder.'/')))) {
            return $this->importProperties($folder);
        }

        array_splice($items, 0, (int) $subCurrentIndex);

        foreach ($items as $index => $filename) {
            $this->cp(str_replace('/upload/', '', $folder).'/000000002/goods/'.$subFolder.'/'.$filename);

            return $this->success(array(
                'filename' => str_replace('/upload/', '', $folder).'/000000002/goods/'.$subFolder.'/'.$filename,
                'step' => 'goods',
                'last_index' => $currentIndex,
                'sub_last_index' => $index
            ));
        }

        return $this->importProperties($folder);
    }

    protected function importProperties($folder, $currentIndex = 0, $subCurrentIndex = 0)
    {
        $items = array_values(array_filter(array_unique(array_map('intval', preg_grep('/^\d+$/', scandir($_SERVER["DOCUMENT_ROOT"].$folder.'/000000002/properties/'))))));
        if (max(array_keys($items)) < (int) $currentIndex) {
            return $this->importProperties($folder);
        }

        $subFolder = $items[$currentIndex];
        if (!($items = preg_grep('/\.xml$/', scandir($_SERVER["DOCUMENT_ROOT"].$folder.'/000000002/properties/'.$subFolder.'/')))) {
            return $this->importProperties($folder);
        }

        array_splice($items, 0, (int) $subCurrentIndex);

        foreach ($items as $index => $filename) {
            $this->cp(str_replace('/upload/', '', $folder).'/000000002/properties/'.$subFolder.'/'.$filename);

            return $this->success(array(
                'filename' => str_replace('/upload/', '', $folder).'/000000002/properties/'.$subFolder.'/'.$filename,
                'step' => 'properties',
                'last_index' => $currentIndex,
                'sub_last_index' => $index
            ));
        }

        return $this->output(array('status' => 'final'));
    }

    protected function cp($filepath, $output = false)
    {
        // echo "<pre>", var_dump(dirname($filepath)), "</pre>";
        shell_exec('mkdir -p '.$_SERVER["DOCUMENT_ROOT"].'/upload/1c_catalog/'.dirname($filepath));
        shell_exec('cp -R '.$_SERVER["DOCUMENT_ROOT"].'/upload/'.$filepath.' '.$_SERVER["DOCUMENT_ROOT"].'/upload/1c_catalog/'.dirname($filepath));

        if ($output === true) {
            $this->success();
        }
    }
}

$post = new MagnificoCatalogImporterPostController();
$post();

require_once($_SERVER["DOCUMENT_ROOT"]."/bitrix/modules/main/include/prolog_after.php");

\CJSCore::init(['jquery']);
?>
<form action="<?=POST_FORM_ACTION_URI?>" method="POST" id="initiator">
    <div>
        <label>Логин</label>
        <input type="text" name="login" value="<?=$request->get('login')?>" />
    </div>
    <div>
        <label>Пароль</label>
        <input type="text" name="password" value="<?=$request->get('password')?>" />
    </div>
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
<div id="log"></div>
<script>
$(function () {

    function MagnificoCatalogImporterPostController(params) {
        this.initialize(params);
    }

    MagnificoCatalogImporterPostController.prototype.initialize = function (params) {
        var self = this;

        self.$initiator = $(params.initiator);
        if (!self.$initiator.length) {
            throw new Error('Initiator not found');
        }

        self.$log = $(params.log);
        if (!self.$initiator.length) {
            throw new Error('Log not found');
        }

        self.$initiator.on('submit', function (e) {
            e.preventDefault();
            e.stopPropagation();

            self.reauth(function () {
                self.importQuery();
            });
        });
    }

    MagnificoCatalogImporterPostController.prototype.reauth = function (callback, filename) {
        var self = this;

        filename = filename || '';
        callback = callback || function () {};

        self.query('/bitrix/admin/1c_exchange.php?type=catalog&mode=checkauth', null, function (response) {
            self.output(response);

            self.query('/bitrix/admin/1c_exchange.php?type=catalog&mode=init&version=' + self.$initiator.find('[name="version"]').val() + '&sessid=' + BX.bitrix_sessid(), null, function (response) {
                self.output(response);

                if (!filename.length) {
                    callback();
                    return;
                }

                self.query(self.$initiator.attr('action'), {
                    filepath: filename,
                    method: 'cp',
                }, function (response) {
                    self.output('Файл ' + filename + ' скопирован');

                    callback();
                });
            }, 'html');
        }, 'html');
    };

    MagnificoCatalogImporterPostController.prototype.query = function (uri, data, callback, dataType) {
        var self = this;

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
            beforeSend: function (xhr) {
                xhr.setRequestHeader("Authorization", "Basic " + btoa(self.$initiator.find('[name="login"]').val() + ":" + self.$initiator.find('[name="password"]').val()));
            },
        }).then(callback, function () {
            self.fail('Что-то пошло не так');
            console.log(arguments);
        });
    };

    MagnificoCatalogImporterPostController.prototype.checkResponse = function (response) {
        var self = this;

        if (typeof response !== 'object' || (response.status !== 'success' && response.status !== 'final')) {
            self.fail(response.messages.join("\n"));
            return false;
        }

        return true;
    };

    MagnificoCatalogImporterPostController.prototype.importFile = function (filename, callback) {
        var self = this;

        filename = filename || '';

        var uri = '/bitrix/admin/1c_exchange.php?type=catalog&mode=import'
                 + '&version=' + self.$initiator.find('[name="version"]').val()
                 + '&filename=' + filename
                 + '&sessid=' + BX.bitrix_sessid();

        self.query(uri, null, function (data) {
            if (data.indexOf('failure') !== -1) {
                self.fail(data);
                setTimeout(function () {
                    self.reauth(function () {
                        self.importFile(filename, callback);
                    }, filename);
                }, 500);
                return;
            }

            if (data.indexOf('success') !== -1) {
                setTimeout(function () {
                    callback(data);
                }, 100);
                return;
            }

            self.output(data);
            self.importFile(filename, callback);
        }, 'html');
    };

    MagnificoCatalogImporterPostController.prototype.importQuery = function (data) {
        var self = this;

        data = data || {};

        self.query(self.$initiator.attr('action'), {
            version: self.$initiator.find('[name="version"]').val(),
            folder: self.$initiator.find('[name="folder"]').val(),
            method: 'import',
            step: data.step ? data.step: null,
            current_index: typeof data.last_index !== 'undefined' && !isNaN(parseInt(data.last_index)) ? parseInt(data.last_index) + 1: null,
            sub_current_index: typeof data.sub_last_index !== 'undefined' && !isNaN(parseInt(data.sub_last_index)) ? parseInt(data.sub_last_index) + 1: null,
        }, function (response) {
            if (!self.checkResponse(response)) {
                return;
            }

            if (response.status === 'final') {
                self.success('Импортированно');
                return;
            }

            self.importFile(response.data.filename, function () {
                self.importQuery(response.data);
            });
        });
    };

    MagnificoCatalogImporterPostController.prototype.output = function (message, color) {
        color = color || 'gray';
        this.$log.prepend('<pre style="color: ' + color + '">' + message + '</pre>');
        this.$log.prepend('<pre style="color: gray">---------</pre>');
    };

    MagnificoCatalogImporterPostController.prototype.success = function (message) {
        this.output(message, 'green');
    };

    MagnificoCatalogImporterPostController.prototype.fail = function (message) {
        this.output(message, 'red');
    };

    window.postController = new MagnificoCatalogImporterPostController({
        initiator: '#initiator',
        log: '#log',
    });
});
</script>
<?php
require_once($_SERVER["DOCUMENT_ROOT"]."/bitrix/footer.php");
