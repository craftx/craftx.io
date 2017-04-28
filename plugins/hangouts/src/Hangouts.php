<?php
namespace selvinortiz\hangouts;

use yii\base\Event;

use craft\base\Plugin;
use craft\web\UrlManager;
use craft\events\RegisterUrlRulesEvent;

use selvinortiz\hangouts\variables\HangoutsVariable;
use selvinortiz\hangouts\controllers\HangoutsDefaultController;

/**
 * Class Hangouts
 *
 * @package selvinortiz\hangouts
 *
 * @property selvinortiz\hangouts\services\HangoutsService $service
 */
class Hangouts extends Plugin
{
    public $controllerMap = [
        'default' => HangoutsDefaultController::class
    ];

    public function init()
    {
        parent::init();

        Event::on(
            UrlManager::class,
            UrlManager::EVENT_REGISTER_SITE_URL_RULES,
            [$this, 'registerSiteRoutes']
        );
    }

    public function registerSiteRoutes(RegisterUrlRulesEvent $event)
    {
        $event->rules['hangouts/next'] = 'hangouts/default/next';
    }

    public function defineTemplateComponent()
    {
        return HangoutsVariable::class;
    }

}


/**
 * @return Hangouts
 */
function hangouts()
{
    return Yii::$app->loadedModules[Hangouts::class] ?? null;
}
