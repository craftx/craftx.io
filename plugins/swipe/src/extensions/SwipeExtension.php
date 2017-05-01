<?php

namespace selvinortiz\swipe\extensions;

use Craft;

use selvinortiz\swipe\Swipe;
use function selvinortiz\swipe\swipe;

class SwipeExtension extends \Twig_Extension {

    const NOTICE_FLASH_KEY = '__notification';

    private $_methods = [
        'setNotice',
        'hasNotice',
        'getNotice'
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

    public function setNotice(string $message) {
        if ($message === null) {
            return Craft::$app->session->getFlash(self::NOTICE_FLASH_KEY);
        }

        Craft::$app->session->setFlash(self::NOTICE_FLASH_KEY, Swipe::t($message));
    }

    public function hasNotice() {
        return Craft::$app->session->hasFlash(self::NOTICE_FLASH_KEY);
    }

    public function getNotice() {
        return Craft::$app->session->getFlash(self::NOTICE_FLASH_KEY);
    }
}
