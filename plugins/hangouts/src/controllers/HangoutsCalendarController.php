<?php
namespace selvinortiz\hangouts\controllers;

use craft\web\Response;
use yii\web\HttpException;

use Craft;
use craft\web\Controller;
use craft\elements\Entry;
use craft\elements\db\EntryQuery;

use function selvinortiz\hangouts\hangouts;

class HangoutsCalendarController extends Controller
{
    protected $allowAnonymous = [
        'serve-calendar-feed',
        'serve-calendar-event',
    ];

    public function actionServeCalendarEvent(string $slug)
    {
        $hangout = (new EntryQuery(Entry::class))
            ->section('hangouts')
            ->slug($slug)
            ->limit(1)
            ->one();

        if (!$hangout)
        {
            throw new HttpException(404);
        }

        return hangouts()->calendar->addEvent($hangout)->sendToDownload();
    }

    public function actionServeCalendarFeed()
    {
        $now = (new \DateTime('now', new \DateTimeZone(Craft::$app->timeZone)));
        $hangouts = (new EntryQuery(Entry::class))
            ->section('hangouts')
            ->hangoutDateTime('>= '.$now->format('Y-m-d H:i:s'))
            ->orderBy('hangoutDateTime desc')
            ->all();

        if (!$hangouts)
        {
            throw new HttpException(404);
        }

        return hangouts()->calendar->addEvents($hangouts)->sendToDownload();
    }
}
