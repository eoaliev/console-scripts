<?php
use Bitrix\Main\Entity\ExpressionField;
use Bitrix\Main\Type\Datetime;
use Elastica\Query;
use Realty\AppKernel;
use Realty\DataManager\OfferTable;
use Realty\Model\Offer;

$container = AppKernel::getInstance()->getContainer();
$qb = $container->get('elastica.querybuilder');
$type = $container->get('elastica.index.realty.offer');
$user = $container->get('user');
$locality = $user->getLastLocation();
$tag = 'sale-flats';
$tagManager = $container->get('offer_tagger');

$start = microtime(true);
$filter = $qb->filter()->bool()
    ->addMust($qb->filter()->term(['STATUS' => OfferTable::STATUS_ACTIVE]))
    ->addMust($qb->filter()->term(['LOCALITY.CODE' => $locality['CODE']]))
    ->addMust($qb->filter()->missing('IMPORT_ID'))
    ->addMust($qb->filter()->range('RECENT_EXPIRE_DATE', ['gte' => (new Datetime())->toString()]));

if ($tag !== null) {
    $filter->addMust($qb->filter()->term(['TAG_SET' => $tag]));
}

$randomQuery = $qb->query()->function_score();
$randomQuery->setFilter($filter);
$randomQuery->addRandomScoreFunction((new Datetime())->getTimestamp());
$query = Query::create(null)
    ->setFields(['ID'])
    ->setSize(3)
    ->setQuery($randomQuery);

$type = $container->get('elastica.index.realty.offer');
$results = $type->search($query);

$ids = [];
foreach ($results as $result) {
    $ids[] = $result->getId();
}

$results = OfferTable::query()
    ->addFilter('=ID', $ids)
    ->addSelect('*')
    ->addSelect(new ExpressionField('ORDER_BY', sprintf('FIELD(`ID`, %s)', implode(', ', $ids))))
    ->addOrder('ORDER_BY', 'ASC')
    ->setLimit(count($ids))
    ->exec()
    ->fetchAll();
$elasticsearchWork = microtime(true) - $start;

var_dump($elasticsearchWork);
//var_dump($results);

$start = microtime(true);
$cats = $tagManager->getTagCategory();
$filter = $tagManager->getEntityFilter($tag);
if (empty($filter['CATEGORY'])) {
    $filter['CATEGORY'] = $cats[$filter['PARENT_CATEGORY']];
}
$results = OfferTable::query()
    ->addFilter('=STATUS', OfferTable::STATUS_ACTIVE)
    ->addFilter('=LOCATION_LOCALITY', $locality['NAME'])
    ->addFilter('=IMPORT_ID', false)
    ->addFilter('>=RECENT_EXPIRE_DATE', (new Datetime()))
    ->addFilter('=CATEGORY', $filter['CATEGORY'])
    ->addSelect('*')
    ->addSelect(new ExpressionField('ORDER_BY', 'RAND()'))
    ->addOrder('ORDER_BY', 'ASC')
    ->setLimit(3)
    //->getQuery();
    ->exec()
    ->fetchAll();
$ormWork = microtime(true) - $start;

var_dump($ormWork);
//var_dump($results);
