<?php

namespace selvinortiz\swipe\extensions;

use Craft;

use selvinortiz\swipe\Swipe;
use function selvinortiz\swipe\swipe;

class SwipeExtension extends \Twig_Extension {
    private $_methods = [
        'notification',
        'url'
    ];

    public function getName() {
        return Swipe::t('Swipe Extension');
    }

    public function getFilters() {
        $filters = [];
        foreach ($this->_methods as $method) {
            $filters[] = new \Twig_SimpleFilter($method, [$this, $method]);
        }

        return $filters;
    }

    public function getFunctions() {
        $functions = [];
        foreach ($this->_methods as $method) {
            $functions[] = new \Twig_SimpleFunction($method, [$this, $method]);
        }

        return $functions;
    }

    public function notification(string $message) {
        if ($message === null) {
            return Craft::$app->session->getFlash('notification');
        }

        Craft::$app->session->setFlash('notification', Swipe::t($message));
    }

    public function url($path) {
        return swipe()->api->incognitoUrl($path);
    }
}
