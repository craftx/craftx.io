<?php
namespace selvinortiz\swipe\variables;

use Craft;
use yii\web\HttpException;
use function selvinortiz\swipe\swipe;

class SwipeVariable {

    public function plans() {
        return swipe()->plans->all();
    }

    public function settings() {
        return swipe()->api->settings();
    }

    public function getSecureUrl(string $video): string {
        return swipe()->videos->getSignedUrl($video);
    }

    public function requireIncognito() {
        $code = Craft::$app->request->getQueryParam('code');
        $appConfig = Craft::$app->config->get('app');

        $allow = false;

        if (! $appConfig['incognito']) {
            $allow = true;
        } elseif ($code === $appConfig['code']) {
            $allow = true;
        } elseif (! Craft::$app->user->getIsGuest()) {
            $allow = true;
        }

        if (!$allow) {
            throw new HttpException(403);
        }
    }

    public function hasIncognitoAccess(): bool {
        $code = Craft::$app->request->getQueryParam('code');
        $appConfig = Craft::$app->config->get('app');

        if (! $appConfig['incognito']) {
            return true;
        }

        if ($code === $appConfig['code']) {
            return true;
        }

        if (! Craft::$app->user->getIsGuest()) {
            return true;
        }

        return false;
    }

    public function incognitoUrl($path) {
        $appConfig = Craft::$app->config->get('app');
        
        if (!empty($appConfig['code'])) {
            return $path.'?code='.$appConfig['code'];
        }

        return $path;
    }
}
