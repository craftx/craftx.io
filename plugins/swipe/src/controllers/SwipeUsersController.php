<?php
namespace selvinortiz\swipe\controllers;

use Craft;
use craft\helpers\UrlHelper;
use craft\web\Controller;

use yii\web\HttpException;

use function selvinortiz\swipe\swipe;

class SwipeUsersController extends Controller {
    /**
     * Not method names but action ids
     * - actionResetPassword() > reset-password
     *
     * @var bool|string[]
     */
    protected $allowAnonymous = [
        'index',
        'save-user',
        'validate-email',
        'validate-username',
        'request-password-reset'
    ];

    private $_userTemplates = 'users';
    private $_dashboardTemplates = 'users/_dashboard';

    public function actionIndex(string $username = '') {
        $template = $this->_userTemplates.'/_index';

        if (!Craft::$app->user->getIsGuest()) {
            $identity = Craft::$app->user->getIdentity();
            $postLoginRedirect = swipe()->api->getPostLoginRedirect($identity);

            // If redirected here from login page because they were logged in
            // We need to update the URL to the proper username
            // Comparison: '@username' == '@selvinortiz'
            if ($username == '@username') {
                Craft::$app->response->redirect(UrlHelper::siteUrl($postLoginRedirect));
            } else if ($username == $postLoginRedirect) {
                $template = $this->_dashboardTemplates.'/profile';
            }
        } else {
            if ($username == '@username' || ! ($identity = Craft::$app->users->getUserByUsernameOrEmail($username))) {
                throw new HttpException(404, 'User with that username does not exist');
            }
        }

        // @todo: Review logic to make sure we cover all cases and refactor
        $avatarUrl = swipe()->api->getGravatar($identity->email ?? '', 128);

        return $this->renderTemplate($template, compact('username', 'avatarUrl'));
    }

    public function actionPage(string $username = '', string $page = '') {
        $this->requireLogin();
        $this->_requireDashboardOwnership($username);

        $template = $this->_dashboardTemplates.'/'.$page;

        if (!Craft::$app->view->doesTemplateExist($template)) {
            throw new HttpException(404);
        }

        return $this->renderTemplate($template);
    }

    public function actionValidateEmail() {
        $email = swipe()->api->getDecodedParam('email');

        if (($user = Craft::$app->users->getUserByUsernameOrEmail($email))) {
            return $this->asJson([
                'status' => '__TAKEN',
                'success' => false,
                'message' => 'Email address already in use'
            ]);
        }

        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            return $this->asJson([
                'status' => '__INVALID',
                'success' => false,
                'message' => 'Email address must be valid'
            ]);
        }

        return $this->asJson([
            'status' => '__OK',
            'success' => true,
            'message' => 'Email address looks good'
        ]);
    }

    public function actionValidateUsername() {
        $username = swipe()->api->getDecodedParam('username');

        if (empty($username)) {
            return $this->asJson([
                'status' => '__EMPTY',
                'success' => false,
                'message' => 'Username is required'
            ]);
        }
        if (($user = Craft::$app->users->getUserByUsernameOrEmail($username))) {
            return $this->asJson([
                'status' => '__TAKEN',
                'success' => false,
                'message' => 'Username is already taken'
            ]);
        }

        if (!preg_match('/^[a-z0-9\-]{5,25}$/', $username)) {
            return $this->asJson([
                'status' => '__INVALID',
                'success' => false,
                'message' => 'Hint > [a-z0-9-]{5,25}'
            ]);
        }

        return $this->asJson([
            'status' => '__OK',
            'success' => true,
            'message' => 'Username looks good'
        ]);
    }

    public function actionRequestPasswordReset() {
        $uoe = Craft::$app->request->getRequiredBodyParam('usernameOrEmail');
        $user = Craft::$app->users->getUserByUsernameOrEmail($uoe);

        if (! $user) {
            Craft::$app->urlManager->setRouteParams(['error' => 'Account not found']);

        }

        Craft::$app->users->sendPasswordResetEmail($user);
        // http://craftx.dev/actions/users/set-password?code=g-o8UxDKok35R20Jzuy9dfsyNOKnoZJF&id=6b6a037c-c82e-43bc-afb4-f7c86856ca45
        return $this->redirectToPostedUrl($user);
    }

    public function actionSaveUser() {
        Craft::$app->request->parsers[] = ['application/json' => 'yii\web\JsonParser'];

        return Craft::$app->runAction('users/save-user');
    }

    private function _requireDashboardOwnership(string $username) {
        if (Craft::$app->user->getIdentity()->username != $username) {
            throw new HttpException(503);
        }
    }
}
