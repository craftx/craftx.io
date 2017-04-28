<?php
namespace selvinortiz\hangouts\controllers;

use craft\web\Controller;
use craft\elements\Entry;
use craft\elements\db\EntryQuery;

class HangoutsDefaultController extends Controller
{
    protected $allowAnonymous = [
        'next'
    ];

    public function actionNext()
    {
        $now = new \DateTime('now', new \DateTimeZone('America/Chicago'));
        $query = new EntryQuery(Entry::class);
        $query->limit = 1;
        $query->section = 'hangouts';
        $query->orderBy = 'hangoutDateTime asc';
        $query->hangoutDateTime = sprintf('> %s', $now->format('Y-m-d H:i'));

        $hangout = $query->one();

        $this->redirect($hangout->url ?? '/hangouts?from=next');
    }
}