<?php
use Elastica\Query;
use Elastica\Script;
use Realty\AppKernel;
use Realty\DataManager\OfferTable;
use Realty\Model\Offer;

$container = AppKernel::getInstance()->getContainer();
$qb = $container->get('elastica.querybuilder');
$type = $container->get('elastica.index.realty.offer');
$client = $container->get('elastica.client');


$offer = OfferTable::query()
    ->addFilter('=ID', 2065569)
    ->addSelect('*')
    ->setLimit(1)
    ->exec()
    ->fetch();

$offer = Offer::create($offer);

$filter = $qb->filter()->bool()
    ->addMustNot($qb->filter()->term(['ID' => $offer['ID']]))
    ->addMust($qb->filter()->term(['STATUS' => OfferTable::STATUS_ACTIVE]))
    ->addMust($qb->filter()->term(['TYPE' => $offer['TYPE']]))
    ->addMust($qb->filter()->term(['CATEGORY' => $offer['CATEGORY']]));

if (!empty($offer['LOCATION_LOCALITY'])) {
    $filter->addMust($qb->filter()->term(['LOCATION_LOCALITY' => $offer['LOCATION_LOCALITY']]));
}

$script = new Script(
    'like-this-offer',
    [
        'document' => $offer->getLikeThisOffersDocument(),
    ],
    Script::LANG_GROOVY
);

$query = Query::create(null)
    ->setFields(['ID'])
    ->setSize(20)
    ->setMinScore(61)
    ->setQuery(
        $qb->query()->function_score()
            ->addScriptScoreFunction($script)
            ->setFilter($filter)

    );

$resultSet = $type->search($query);

var_dump($resultSet);