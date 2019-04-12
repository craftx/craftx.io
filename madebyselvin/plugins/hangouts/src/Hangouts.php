<?php
namespace selvinortiz\hangouts;

use Yii;
use yii\base\Event;

use Craft;
use craft\base\Plugin;
use craft\web\UrlManager;
use craft\events\RegisterUrlRulesEvent;

use selvinortiz\hangouts\services\HangoutsService;
use selvinortiz\hangouts\services\HangoutsCalendarService;
use selvinortiz\hangouts\twig\HangoutsTemplateComponent;
use selvinortiz\hangouts\twig\HangoutsTemplateExtension;
use selvinortiz\hangouts\controllers\HangoutsController;
use selvinortiz\hangouts\controllers\HangoutsCalendarController;

/**
 * Class Hangouts
 *
 * @package selvinortiz\hangouts
 *
 * @property HangoutsService $service
 * @property HangoutsCalendarService $calendar
 */
class Hangouts extends Plugin
{
    public $controllerMap = [
        'default' => HangoutsController::class,
        'calendar' => HangoutsCalendarController::class
    ];

    public function init()
    {
        parent::init();

        Craft::$app->view->hook('hangouts', '\\selvinortiz\\hangouts\\twig\\HangoutsTemplateHooks::hangouts');
        Craft::$app->view->hook('hangout', '\\selvinortiz\\hangouts\\twig\\HangoutsTemplateHooks::hangout');
        Craft::$app->view->hook('profile', '\\selvinortiz\\hangouts\\twig\\HangoutsTemplateHooks::profile');
        Craft::$app->view->registerTwigExtension(new HangoutsTemplateExtension());

        Event::on(
            UrlManager::class,
            UrlManager::EVENT_REGISTER_SITE_URL_RULES,
            [$this, 'registerSiteRoutes']
        );
    }

    public function registerSiteRoutes(RegisterUrlRulesEvent $event)
    {
        $event->rules['hangouts/next'] = 'hangouts/default/next';
        $event->rules['hangouts.ics'] = 'hangouts/calendar/serve-calendar-feed';
        $event->rules['hangouts/<slug:{slug}>.ics'] = 'hangouts/calendar/serve-calendar-event';
    }

    public function defineTemplateComponent()
    {
        return HangoutsTemplateComponent::class;
    }
}


/**
 * @return Hangouts
 */
function hangouts()
{
    return Yii::$app->loadedModules[Hangouts::class] ?? null;
}
