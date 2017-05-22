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
    private $usernameBlacklist = array('400', '401', '403', '404', '405', '406', '407', '408', '409', '410', '411', '412', '413', '414', '415', '416', '417', '421', '422', '423', '424', '426', '428', '429', '431', '500', '501', '502', '503', '504', '505', '506', '507', '508', '509', '510', '511', 'about', 'about-us', 'abuse', 'access', 'account', 'accounts', 'ad', 'add', 'admin', 'administration', 'administrator', 'ads', 'advertise', 'advertising', 'aes128-ctr', 'aes128-gcm', 'aes192-ctr', 'aes256-ctr', 'aes256-gcm', 'affiliate', 'affiliates', 'ajax', 'alert', 'alerts', 'alpha', 'amp', 'analytics', 'api', 'app', 'apps', 'asc', 'assets', 'atom', 'auth', 'authentication', 'authorize', 'autoconfig', 'avatar', 'backup', 'banner', 'banners', 'beta', 'billing', 'billings', 'blog', 'blogs', 'board', 'bookmark', 'bookmarks', 'broadcasthost', 'business', 'buy', 'cache', 'calendar', 'campaign', 'captcha', 'careers', 'cart', 'cas', 'categories', 'category', 'cdn', 'cgi', 'cgi-bin', 'chacha20-poly1305', 'change', 'channel', 'channels', 'chart', 'chat', 'checkout', 'clear', 'client', 'close', 'cms', 'com', 'comment', 'comments', 'community', 'compare', 'compose', 'config', 'connect', 'contact', 'contest', 'cookies', 'copy', 'copyright', 'count', 'create', 'css', 'curve25519-sha256', 'customer', 'customers', 'customize', 'dashboard', 'db', 'deals', 'debug', 'delete', 'desc', 'dev', 'developer', 'developers', 'diffie-hellman-group-exchange-sha256', 'diffie-hellman-group14-sha1', 'disconnect', 'discuss', 'dns', 'dns0', 'dns1', 'dns2', 'dns3', 'dns4', 'docs', 'documentation', 'domain', 'download', 'downloads', 'downvote', 'draft', 'drop', 'ecdh-sha2-nistp256', 'ecdh-sha2-nistp384', 'ecdh-sha2-nistp521', 'edit', 'editor', 'email', 'enterprise', 'error', 'errors', 'event', 'events', 'example', 'exception', 'exit', 'explore', 'export', 'extensions', 'false', 'family', 'faq', 'faqs', 'features', 'feed', 'feedback', 'feeds', 'feeds', 'file', 'files', 'filter', 'follow', 'follower', 'followers', 'following', 'fonts', 'forgot', 'forgot-password', 'forgotpassword', 'form', 'forms', 'forum', 'forums', 'friend', 'friends', 'ftp', 'get', 'git', 'go', 'group', 'groups', 'guest', 'guidelines', 'guides', 'head', 'header', 'help', 'hide', 'hmac-sha', 'hmac-sha1', 'hmac-sha1-etm', 'hmac-sha2-256', 'hmac-sha2-256-etm', 'hmac-sha2-512', 'hmac-sha2-512-etm', 'home', 'host', 'hosting', 'hostmaster', 'htpasswd', 'http', 'httpd', 'https', 'icons', 'images', 'imap', 'img', 'import', 'info', 'insert', 'investors', 'invitations', 'invite', 'invite', 'invites', 'invoice', 'is', 'isatap', 'issues', 'it', 'jobs', 'join', 'js', 'json', 'learn', 'legal', 'licensing', 'limit', 'live', 'load', 'local', 'localdomain', 'localhost', 'lock', 'login', 'logout', 'lost-password', 'mail', 'mail0', 'mail1', 'mail2', 'mail3', 'mail4', 'mail5', 'mail6', 'mail7', 'mail8', 'mail9', 'mailer-daemon', 'mailerdaemon', 'map', 'marketing', 'marketplace', 'master', 'me', 'media', 'member', 'members', 'message', 'messages', 'metrics', 'mis', 'mobile', 'moderator', 'modify', 'more', 'mx', 'my', 'net', 'network', 'new', 'news', 'newsletter', 'newsletters', 'next', 'nil', 'no-reply', 'nobody', 'noc', 'none', 'noreply', 'notification', 'notifications', 'ns', 'ns0', 'ns1', 'ns2', 'ns3', 'ns4', 'ns5', 'ns6', 'ns7', 'ns8', 'ns9', 'null', 'oauth', 'oauth2', 'offer', 'offers', 'online', 'openid', 'order', 'orders', 'overview', 'owner', 'page', 'pages', 'partners', 'passwd', 'password', 'pay', 'payment', 'payments', 'photo', 'photos', 'pixel', 'plans', 'plugins', 'policies', 'policy', 'pop', 'pop3', 'popular', 'portfolio', 'post', 'postfix', 'postmaster', 'poweruser', 'preferences', 'premium', 'press', 'previous', 'pricing', 'print', 'privacy', 'privacy-policy', 'private', 'prod', 'product', 'production', 'profile', 'profiles', 'project', 'projects', 'public', 'purchase', 'put', 'quota', 'redirect', 'reduce', 'refund', 'refunds', 'register', 'registration', 'remove', 'replies', 'reply', 'report', 'request', 'request-password', 'reset', 'reset-password', 'response', 'return', 'returns', 'review', 'reviews', 'root', 'rootuser', 'rsa-sha2-2', 'rsa-sha2-512', 'rss', 'rules', 'sales', 'save', 'script', 'sdk', 'search', 'secure', 'security', 'select', 'services', 'session', 'sessions', 'settings', 'setup', 'share', 'shift', 'shop', 'signin', 'signup', 'site', 'sitemap', 'sites', 'smtp', 'sort', 'source', 'sql', 'ssh', 'ssh-rsa', 'ssl', 'ssladmin', 'ssladministrator', 'sslwebmaster', 'stage', 'staging', 'stat', 'static', 'statistics', 'stats', 'status', 'store', 'style', 'styles', 'stylesheet', 'stylesheets', 'subdomain', 'subscribe', 'sudo', 'super', 'superuser', 'support', 'survey', 'sync', 'sysadmin', 'system', 'tablet', 'tag', 'tags', 'team', 'telnet', 'terms', 'terms-of-use', 'test', 'testimonials', 'theme', 'themes', 'today', 'tools', 'topic', 'topics', 'tour', 'training', 'translate', 'translations', 'trending', 'trial', 'true', 'umac-128', 'umac-128-etm', 'umac-64', 'umac-64-etm', 'undefined', 'unfollow', 'unsubscribe', 'update', 'upgrade', 'usenet', 'user', 'username', 'users', 'uucp', 'var', 'verify', 'video', 'view', 'void', 'vote', 'webmail', 'webmaster', 'website', 'widget', 'widgets', 'wiki', 'wpad', 'write', 'www', 'www-data', 'www1', 'www2', 'www3', 'www4', 'you', 'yourname', 'yourusername', 'zlib');


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

        // 5-25 characters
        if (!preg_match('/^.{5,25}$/', $username)) {
            return $this->asJson([
                'status' => '__INVALID',
                'success' => false,
                'message' => 'Username must be 5 - 25 characters'
            ]);
        }

        // Only letters, numbers, and hyphens
        if (!preg_match('/^[a-zA-Z\d\-]*$/', $username)) {
            return $this->asJson([
                'status' => '__INVALID',
                'success' => false,
                'message' => 'Username must only contain letters, numbers, and hyphens'
            ]);
        }

        // Must contain at least one letter
        if (!preg_match('/[a-zA-Z]+/', $username)) {
            return $this->asJson([
                'status' => '__INVALID',
                'success' => false,
                'message' => 'Username must contain at least one letter'
            ]);
        }

        // Must not be in the blacklisted usernames
        if (in_array($username, $this->usernameBlacklist)) {
          return $this->asJson([
              'status' => '__INVALID',
              'success' => false,
              'message' => 'That username is blacklisted, please choose another'
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
