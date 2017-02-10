<?php
namespace selvinortiz\swipe\services;

use craft\base\Component;

use function selvinortiz\swipe\swipe;

class SwipeService extends Component
{
    public function settings()
    {
        return swipe()->getSettings();
    }
}
