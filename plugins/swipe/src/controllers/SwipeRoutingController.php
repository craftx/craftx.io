<?php
namespace selvinortiz\swipe\controllers;

use Craft;
use craft\web\Controller;

class SwipeRoutingController extends Controller {
    const MESSAGE_FLASH_KEY = 'notification';
    const MESSAGE_ACCOUNT_ACTIVATED = 'Your account was activated successfully, welcome aboard.';
    const DESTINATION_ACCOUNT_ACTIVATED = '/login';

    protected $allowAnonymous = true;

    public function actionAccountActivated() {
        Craft::$app->session->setFlash(self::MESSAGE_FLASH_KEY, self::MESSAGE_ACCOUNT_ACTIVATED);

        return $this->redirect(self::DESTINATION_ACCOUNT_ACTIVATED);
    }
}