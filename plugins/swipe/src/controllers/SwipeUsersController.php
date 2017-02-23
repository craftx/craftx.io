<?php
namespace selvinortiz\swipe\controllers;

use Craft;
use craft\helpers\UrlHelper;
use craft\web\Controller;

use function selvinortiz\swipe\swipe;
use yii\web\HttpException;

class SwipeUsersController extends Controller {
    /**
     * Not method names but action ids
     * - actionResetPassword() > reset-password
     *
     * @var bool|string[]
     */
    protected $allowAnonymous = [
        'index',
        'request-password-reset'
    ];

    private $_userTemplates = '_users';
    private $_dashboardTemplates = '_users/dashboard';

    public function actionIndex(string $username = '') {
        $template = $this->_userTemplates;
        $userSegment = Craft::$app->request->getSegment(1);

        if (!Craft::$app->user->getIsGuest()) {
            $identity = Craft::$app->user->getIdentity();
            $postLoginRedirect = swipe()->api->getPostLoginRedirect($identity);

            // If redirected here from login page because they were logged in
            // We need to update the URL to the proper username
            // Comparison: '@username' == '@selvinortiz'
            if ($userSegment == '@username') {
                Craft::$app->response->redirect(UrlHelper::siteUrl($postLoginRedirect));
            } else if ($userSegment == $postLoginRedirect) {
                $template = $this->_dashboardTemplates;
            }
        } else {
            if ($userSegment == '@username') {
                throw new HttpException(404, 'User with that username does not exist');
            }
        }

        // @todo: Review logic to make sure we cover all cases and refactor
        $avatarUrl = swipe()->api->getGravatar(Craft::$app->user->identity->email ?? '', 128);

        return $this->renderTemplate($template, compact('username', 'avatarUrl'));
    }

    public function actionRequestPasswordReset() {
        $uoe = Craft::$app->request->getRequiredBodyParam('usernameOrEmail');
        $user = Craft::$app->users->getUserByUsernameOrEmail($uoe);

        if (! $user) {
            Craft::$app->urlManager->setRouteParams(['error' => 'Account not found']);

        }

        Craft::$app->users->sendPasswordResetEmail($user);
        http://craftx.dev/actions/users/set-password?code=g-o8UxDKok35R20Jzuy9dfsyNOKnoZJF&id=6b6a037c-c82e-43bc-afb4-f7c86856ca45
        return $this->redirectToPostedUrl($user);
    }
}
