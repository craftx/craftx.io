<?php
namespace selvinortiz\swipe\variables;

use Craft;
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
}
