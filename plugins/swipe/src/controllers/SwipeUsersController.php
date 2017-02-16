<?php
namespace selvinortiz\swipe\controllers;

use Craft;
use craft\web\Controller;

use function selvinortiz\swipe\swipe;

class SwipeUsersController extends Controller {
    protected $allowAnonymous = ['actionIndex'];

    private $_userTemplates = '_users';
    private $_dashboardTemplates = '_users/dashboard';

    public function actionIndex(string $username = '') {
        $template = $this->_userTemplates;

        if (!Craft::$app->user->getIsGuest()) {
            $template = $this->_dashboardTemplates;
        }

        $avatarUrl = swipe()->api->getGravatar(Craft::$app->user->identity->email, 128);

        return $this->renderTemplate($template, compact('username', 'avatarUrl'));
    }
}
