<?php
namespace selvinortiz\hangouts;

use Yii;
use yii\base\Event;

use Craft;
use craft\base\Plugin;
use craft\web\UrlManager;
use craft\events\RegisterUrlRulesEvent;

use selvinortiz\hangouts\twig\HangoutsExtension;
use selvinortiz\hangouts\services\HangoutsService;
use selvinortiz\hangouts\twig\HangoutsTemplateComponent;
use selvinortiz\hangouts\controllers\HangoutsController;

/**
 * Class Hangouts
 *
 * @package selvinortiz\hangouts
 *
 * @property HangoutsService
 */
class Hangouts extends Plugin
{
    public $controllerMap = [
        'default' => HangoutsController::class
    ];

    public function init()
    {
        parent::init();

        Craft::$app->view->twig->addExtension(new HangoutsExtension());

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
