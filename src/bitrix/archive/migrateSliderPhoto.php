<?php
use Realty\ServiceContainer;
use Realty\ContentSliderTable;

$imagine = ServiceContainer::getInstance()->get('imagine');

$sliders = ContentSliderTable::query()
    ->setSelect(['ID', 'FILE'])
    ->addOrder('ID', 'ASC')
    ->addFilter('!FILE', false)
    ->exec();

while ($slider = $sliders->fetch()) {
    $files = array_filter($slider['FILE'], 'is_numeric');

    $updatefiles = [];
    foreach ($files as $file) {
        $filearray = \CFile::getFileArray($file);

        try {
            $filename = $_SERVER['DOCUMENT_ROOT'].'/upload/tmp/'.\Rhumsaa\Uuid\Uuid::uuid4()->toString().'.jpg';
            $image = $imagine->open($_SERVER['DOCUMENT_ROOT'].$filearray['SRC'])->save($filename, ['jpeg_quality' => 85]);
        } catch (ImagineException $ex) {
            $filename = false;
            $errors = sprintf('Downloaded file is not an image Exception_message: %s', $ex->getMessage());
        }
        if ($filename !== false) {
            if ($file = CFile::MakeFileArray($filename)) {
                $file['MODULE_ID'] = 'realty';
                if ($id = CFile::SaveFile($file, 'realty/contentslider/', true)) {
                    $updatefiles[] = $id;
                    if (!empty($filearray['DESCRIPTION'])) {
                        CFile::UpdateDesc($id, $filearray['DESCRIPTION']);
                    }
                }
            }
            @unlink($filename);
            \CFile::delete($filearray['ID']);
        }
    }

    echo '<pre>', print_r($updatefiles), '</pre>';

    $result = ContentSliderTable::update($slider['ID'], ['FILE' => $updatefiles]);
    var_dump($result->isSuccess());
}