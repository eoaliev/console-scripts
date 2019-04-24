<?php

\Bitrix\Main\Loader::includeModule('crm');
\Bitrix\Main\Loader::includeModule('bizprofi.realty');

$map = [];

class ParseRealtyManager
{
    const BUILDING_ROS = 138;
    const BUILDING_ARBAT = 1576;

    const HOUSE_IBLOCK_ID = 41;
    const HOUSE_BUILDING_BINDING = 137;

    const SECTION_IBLOCK_ID = 43;
    const SECTION_HOUSE_BINDING = 205;

    const OFFER_IBLOCK_ID = 42;
    const OFFER_SECTION_BINDING = 209;

    protected $cache = [];
    protected static $globalCache = [];

    protected $row = [];

    function __construct(array $row)
    {
        $this->row = $row;
    }

    function getBuildingId(): int
    {
        $cache = &$this->cache['getBuildingId'];
        if (is_numeric($cache)) {
            return $cache;
        }

        $object = (int) $this->row['UF_CRM_5BA8C9D35B6C3'];
        if (176 === $object) {
            return $cache = static::BUILDING_ARBAT;
        }

        if (198 === $object) {
            return $cache = static::BUILDING_ROS;
        }

        $address = strtolower($this->row['UF_CRM_1518701657']);
        if (0 === strpos($address, 'жк арбатский')) {
            return $cache = static::BUILDING_ARBAT;
        }

        if (0 === strpos($address, 'арбатский')) {
            return $cache = static::BUILDING_ARBAT;
        }

        if (0 === strpos($address, 'россинский парк')) {
            return $cache = static::BUILDING_ROS;
        }

        return $cache = 0;
    }

    function getHouseId(): int
    {
        $cache = &$this->cache['getHouseId'];
        if (is_numeric($cache)) {
            return $cache;
        }

        if (0 < (int) $this->row['UF_CRM_1520154220122']) {
            $houseName = 'литер '.$this->row['UF_CRM_1520154220122'];
        } else {
            list($buildingName, $houseName, $sectionName) = array_map(
                'trim',
                explode(',', $this->row['UF_CRM_1518701657'])
            );

            $houseName = strtolower(
                str_replace('-', ' ', $houseName)
            );
        }

        if (!($buildingId = $this->getBuildingId())) {
            return $cache = 0;
        }

        $map = $this->getHouseBuildingMappingByBuildingId(
            $buildingId
        );

        if (0 >= count($map)) {
            return $cache = 0;
        }

        foreach ($map as $row) {
            if (0 === strpos($row['name'], $houseName)) {
                return $cache = $row['element_id'];
            }
        }

        return $cache = 0;
    }

    function getSectionId(): int
    {
        $cache = &$this->cache['getSectionId'];
        if (is_numeric($cache)) {
            return $cache;
        }

        $sectionNumber = 0;
        if (0 < (int) $this->row['UF_CRM_1520154228604']) {
            $sectionNumber = (int) $this->row['UF_CRM_1520154228604'];
        } else {
            list($buildingName, $houseName, $sectionName) = array_map(
                'trim',
                explode(',', $this->row['UF_CRM_1518701657'])
            );

            $sectionNumber = intVal(
                str_replace('Подъезд-', '', $sectionName)
            );
        }

        $maps = [];

        $map = $this->getSectionHouseMappingByHouseId(
            $this->getHouseId()
        );

        if (0 <= count($map)) {
            $maps[] = $map;
        }

        $maps = array_filter($maps);
        if (0 >= count($maps)) {
            $houseMapping = $this->getHouseBuildingMappingByBuildingId(
                $this->getBuildingId()
            );

            foreach ($houseMapping as $houseId => $row) {
                $maps[] = $subMap;
            }
        }

        $maps = array_filter($maps);
        if (0 >= count($maps)) {
            return $cache = 0;
        }

        foreach ($maps as $map) {
            foreach ($map as $row) {
                if ((int) $row['name'] === $sectionNumber) {
                    return $cache = $row['element_id'];
                }
            }
        }

        return $cache = 0;
    }

    function getOfferId(): int
    {
        $cache = &$this->cache['getOfferId'];
        if (is_numeric($cache)) {
            return $cache;
        }

        $offerNumber = (int) $this->row['UF_CRM_5A0ACEE88D333'];
        if (0 >= $offerNumber) {
            return $cache = 0;
        }

        $maps = [];

        $map = $this->getOfferSectionMappingBySectionId(
            $this->getSectionId()
        );

        if (0 <= count($map)) {
            $maps[] = $map;
        }

        $maps = array_filter($maps);
        if (0 >= count($maps)) {
            $sectionMapping = $this->getSectionHouseMappingByHouseId(
                $this->getHouseId()
            );

            foreach ($sectionMapping as $sectionId => $row) {
                $maps[] = $this->getOfferSectionMappingBySectionId(
                    $sectionId
                );
            }
        }

        $maps = array_filter($maps);
        if (0 >= count($maps)) {
            $houseMapping = $this->getHouseBuildingMappingByBuildingId(
                $this->getBuildingId()
            );

            foreach ($houseMapping as $houseId => $row) {
                $sectionMapping = $this->getSectionHouseMappingByHouseId(
                    $houseId
                );

                foreach ($sectionMapping as $sectionId => $row) {
                    $maps[] = $this->getOfferSectionMappingBySectionId(
                        $sectionId
                    );
                }
            }
        }

        $maps = array_filter($maps);
        if (0 >= count($maps)) {
            return $cache = 0;
        }

        foreach ($maps as $map) {
            foreach ($map as $row) {
                if (0 === strpos($row['name'], 'квартира '.$offerNumber)) {
                    return $cache = $row['element_id'];
                }
            }
        }

        return $cache = 0;
    }

    function getHouseBuildingMapping(): array
    {
        return $this->getBindingMapping(
            static::HOUSE_IBLOCK_ID,
            static::HOUSE_BUILDING_BINDING
        );
    }

    function getSectionHouseMapping(): array
    {
        return $this->getBindingMapping(
            static::SECTION_IBLOCK_ID,
            static::SECTION_HOUSE_BINDING
        );   
    }

    function getOfferSectionMapping(): array
    {
        return $this->getBindingMapping(
            static::OFFER_IBLOCK_ID,
            static::OFFER_SECTION_BINDING
        );
    }

    function getBindingMapping($iblockId, $bindingPropertyId): array
    {
        $cache = &$this->globalCache[md5(
            serialize(['getBindingMapping', $iblockId, $bindingPropertyId])
        )];
        if (is_array($cache)) {
            return $cache;
        }

        $rows = \Bizprofi\Realty\DataManager\Iblock\ElementPropertyTable::query()
            ->addSelect('*')
            ->addSelect('ELEMENT.NAME', 'ELEMENT_NAME')
            ->where('ELEMENT.IBLOCK_ID', $iblockId)
            ->where('IBLOCK_PROPERTY_ID', $bindingPropertyId)
            ->exec();

        $map = [];
        while ($row = $rows->fetch()) {
            $map[(int) $row['VALUE']][(int) $row['IBLOCK_ELEMENT_ID']] = [
                'name' => strtolower(
                    $row['ELEMENT_NAME']
                ),
                'element_id' => (int) $row['IBLOCK_ELEMENT_ID'],
            ];
        }

        return $cache = $map;
    }

    function getHouseBuildingMappingByBuildingId(int $buildingId): array
    {
        if (0 >= $buildingId) {
            return [];
        }

        $map = $this->getHouseBuildingMapping();

        return $map[$buildingId] ?: [];
    }

    function getSectionHouseMappingByHouseId(int $houseId): array
    {
        if (0 >= $houseId) {
            return [];
        }

        $map = $this->getSectionHouseMapping();

        return $map[$houseId] ?: [];
    }

    function getOfferSectionMappingBySectionId(int $houseId): array
    {
        if (0 >= $houseId) {
            return [];
        }

        $map = $this->getOfferSectionMapping();

        return $map[$houseId] ?: [];
    }
};

$rows = \Bitrix\Crm\DealTable::query()
    ->addSelect('**')
    ->where(
        \Bitrix\Main\ORM\Query\Query::filter()
            ->logic('or')
            ->whereNotNull('UF_CRM_5BA8C9D35B6C3')
            ->whereNotNull('UF_CRM_1520154220122')
            ->whereNotNull('UF_CRM_1518701657')
            ->whereNotNull('UF_CRM_1520154228604')
            ->whereNotNull('UF_CRM_5A0ACEE88D333')
    )
    ->exec();

var_dump($rows->getSelectedRowsCount());

$entity = new \CCrmDeal(false);

$i = 0;
while ($row = $rows->fetch()) {
    $manager = new ParseRealtyManager($row);

    $fields = array_filter([
        'BUILDING_ID' => $manager->getBuildingId(),
        'HOUSE_ID' => $manager->getHouseId(),
        'SECTION_ID' => $manager->getSectionId(),
        'OFFER_ID' => $manager->getOfferId(),
        'DEAL_ID' => (int) $row['ID'],
    ]);
    if (0 >= (int) $fields['OFFER_ID']) {
        if (!in_array((int) $row['UF_CRM_5BA8C9D35B6C3'], [176, 198], true)) {
            continue;
        }

        var_dump($fields);
        continue;
    }

    $i++;

    $updateFields = ['UF_CRM_1556006686525' => (int) $fields['OFFER_ID']];

    var_dump($entity->update($row['ID'], $updateFields));
}

var_dump($i);
