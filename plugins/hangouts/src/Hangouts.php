<?php
namespace selvinortiz\hangouts;

use Yii;
use yii\base\Event;

use Craft;
use craft\base\Plugin;
use craft\web\UrlManager;
use craft\events\RegisterUrlRulesEvent;

use selvinortiz\hangouts\services\HangoutsService;
use selvinortiz\hangouts\controllers\HangoutsController;
use selvinortiz\hangouts\twig\HangoutsTemplateExtension;
use selvinortiz\hangouts\twig\HangoutsTemplateComponent;

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

        Craft::$app->view->hook('hangout', '\\selvinortiz\\hangouts\\twig\\HangoutsTemplateHooks::hangout');
        Craft::$app->view->twig->addExtension(new HangoutsTemplateExtension());

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
