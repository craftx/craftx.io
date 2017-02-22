<?php
namespace selvinortiz\swipe;

use Yii;
use yii\base\Event;
use yii\web\UserEvent;

use Craft;
use craft\web\User;
use craft\base\Plugin;
use craft\web\UrlManager;
use craft\events\RegisterUrlRulesEvent;

use selvinortiz\swipe\services\SwipeService;
use selvinortiz\swipe\services\SwipePlanService;
use selvinortiz\swipe\services\SwipeVideoService;
use selvinortiz\swipe\variables\SwipeVariable;
use selvinortiz\swipe\models\SwipeSettingsModel;
use selvinortiz\swipe\controllers\SwipeUsersController;
use selvinortiz\swipe\controllers\SwipePlansController;
use selvinortiz\swipe\controllers\SwipeNewsletterController;

/**
 * Class Swipe
 *
 * @package selvinortiz\swipe
 *
 * @property SwipeService $api
 * @property SwipePlanService $plans
 * @property SwipeVideoService $videos
 */
class Swipe extends Plugin {

    public $controllerMap = [
        'users' => SwipeUsersController::class,
        'plans' => SwipePlansController::class,
        'newsletter' => SwipeNewsletterController::class,
    ];

    public function init() {
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
        parent::init();

    }

    public function registerCpRoutes(RegisterUrlRulesEvent $event) {
        $event->rules['swipe/plans/new'] = 'swipe/plans/edit';
        $event->rules['swipe/plans/edit/<id:[a-zA-Z\-]+>'] = 'swipe/plans/edit';
    }

    public function registerSiteRoutes(RegisterUrlRulesEvent $event) {
        $event->rules['@<username:[a-z0-9\-]+>'] = 'swipe/users/index';
    }

    public function handleAfterLogin(UserEvent $event) {
        $redirect = Craft::$app->view->renderObjectTemplate(
            Craft::$app->config->get('postLoginRedirect'),
            [
                'email' => $event->identity->email,
                'username' => $event->identity->username,
            ]
        );

        Craft::$app->config->set('postLoginRedirect', $redirect);
    }

    public function createSettingsModel(): SwipeSettingsModel {
        return new SwipeSettingsModel(Craft::$app->getConfig()->getConfigSettings($this->handle));
    }

    public function defineTemplateComponent() {
        return SwipeVariable::class;
    }

    public function t($text, array $vars = []): string {
        return Craft::t($text, $vars, 'swipe');
    }
}

/**
 * @return Swipe
 */
function swipe() {
    return  Yii::$app->loadedModules[Swipe::class] ?? null;
}
