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
        'render-event',
        'render-calendar'
    ];

    public function actionRenderEvent(string $slug)
    {
        // $now = (new \DateTime('now', new \DateTimeZone(Craft::$app->timeZone)));
        $hangout = (new EntryQuery(Entry::class))
            ->section('hangouts')
            ->slug($slug)
            ->limit(1)
            ->one();

        if (!$hangout)
        {
            throw new HttpException(404);
        }

        $response = new Response();
        $headers  = $response->headers;
        $content  = hangouts()->service->renderIcsFromHangout($hangout);
        // $response->content = $content;
        $headers->set('Content-Type', 'text/calendar; charset=utf-8');

        return $response->sendContentAsFile($content, sprintf('craftx-hangout-%s.ics', $hangout->slug));
    }

    public function actionRenderCalendar()
    {
        $now = (new \DateTime('now', new \DateTimeZone(Craft::$app->timeZone)));
        $hangouts = (new EntryQuery(Entry::class))
            ->section('hangouts')
            ->hangoutDateTime('>= '.$now->format('Y-m-d H:i:s'))
            ->all();

        if (!$hangouts)
        {
            throw new HttpException(404);
        }

        $response = new Response();
        $headers  = $response->headers;
        $content  = hangouts()->service->renderCalendarFromHangout($hangouts);

        $headers->set('Content-Type', 'text/calendar; charset=utf-8');

        return $response->sendContentAsFile($content, 'craftx-hangouts.ics');
    }
}
