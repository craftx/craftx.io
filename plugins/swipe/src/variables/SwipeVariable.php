<?php
namespace selvinortiz\swipe\variables;

use yii\web\HttpException;

use Craft;

use function selvinortiz\swipe\swipe;

class SwipeVariable
{

    public function plans()
    {
        return swipe()->plans->all();
    }

    public function settings()
    {
        return swipe()->api->settings();
    }

    public function getSecureUrl(string $video): string
    {
        return swipe()->videos->getSignedUrl($video);
    }
}
