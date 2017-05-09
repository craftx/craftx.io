<?php
namespace selvinortiz\swipe;

use Yii;
use yii\base\Event;
use yii\web\UserEvent;

use Craft;
use craft\web\User;
use craft\base\Plugin;
use craft\web\UrlManager;
use craft\events\ModelEvent;
use craft\events\RegisterUrlRulesEvent;

use selvinortiz\swipe\services\SwipeService;
use selvinortiz\swipe\services\SwipePlanService;
use selvinortiz\swipe\services\SwipeVideoService;
use selvinortiz\swipe\extensions\SwipeExtension;
use selvinortiz\swipe\variables\SwipeVariable;
use selvinortiz\swipe\models\SwipeSettingsModel;
use selvinortiz\swipe\controllers\SwipeUsersController;
use selvinortiz\swipe\controllers\SwipePlansController;
use selvinortiz\swipe\controllers\SwipeRoutingController;
use selvinortiz\swipe\controllers\SwipeNewsletterController;

/**
 * Class Swipe
 *
 * @package selvinortiz\swipe
 *
 * @property SwipeService      $api
 * @property SwipePlanService  $plans
 * @property SwipeVideoService $videos
 */
class Swipe extends Plugin
{

    public $controllerMap = [
        'users' => SwipeUsersController::class,
        'plans' => SwipePlansController::class,
        'routing' => SwipeRoutingController::class,
        'newsletter' => SwipeNewsletterController::class,
    ];

    public function init()
    {
        parent::init();

        Craft::$app->view->twig->addExtension(new SwipeExtension());

        Event::on(
            UrlManager::class,
            UrlManager::EVENT_REGISTER_CP_URL_RULES,
            [$this, 'registerCpRoutes']
        );

        Event::on(
            UrlManager::class,
            UrlManager::EVENT_REGISTER_SITE_URL_RULES,
            [$this, 'registerSiteRoutes']
        );

        Event::on(
            User::class,
            User::EVENT_AFTER_LOGIN,
            [$this, 'handleAfterLogin']
        );

        Event::on(
            \craft\elements\User::class,
            \craft\elements\User::EVENT_AFTER_SAVE,
            [$this, 'handleAfterSave']
        );
    }

    public function registerCpRoutes(RegisterUrlRulesEvent $event)
    {
        $event->rules['swipe/plans/new'] = 'swipe/plans/edit';
        $event->rules['swipe/plans/edit/<id:[a-zA-Z\-]+>'] = 'swipe/plans/edit';
    }

    public function registerSiteRoutes(RegisterUrlRulesEvent $event)
    {
        // $event->rules['@<username:[a-z0-9\-]+>'] = 'swipe/users/index';
        // $event->rules['@<username:[a-z0-9\-]+>/<page:[^/]+>'] = 'swipe/users/page';
    }

    public function handleAfterLogin(UserEvent $event)
    {
        Craft::$app->config->general->postLoginRedirect = swipe()->api->getPostLoginRedirect($event->identity);
    }

    public function handleAfterSave(ModelEvent $event)
    {
        if ($event->isNew && $event->isValid) {
            return swipe()->plans->createSubscription($event->sender);
        }
    }

    public function createSettingsModel(): SwipeSettingsModel
    {
        return new SwipeSettingsModel();
    }

    public function defineTemplateComponent()
    {
        return SwipeVariable::class;
    }

    public static function t($text, array $vars = []): string
    {
        return Craft::t('swipe', $text, $vars);
    }
}

/**
 * @return Swipe
 */
function swipe()
{
    return Yii::$app->loadedModules[Swipe::class] ?? null;
}
