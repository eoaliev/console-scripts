<?php
use Realty\DataManager\OfferTable;
use Realty\Model\Offer;

function offerRescoreRating($id)
{
    $row = OfferTable::query()
        ->addFilter('=ID', $id)
        ->setLimit(1)
        ->addSelect('*')
        ->exec()
        ->fetch();

    if ($row !== false) {
        $offer = Offer::create($row);
        $value = $offer->getRating()->getValue();

        if ($row['RATING'] !== $value) {
            $result = OfferTable::update($row['ID'], ['RATING' => $value]);
            return $result->isSuccess();
        }
    }

    return false;
}