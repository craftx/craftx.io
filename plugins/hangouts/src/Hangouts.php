<?php
namespace selvinortiz\hangouts;

use craft\base\Plugin;

/**
 * Class Hangouts
 *
 * @package selvinortiz\hangouts
 *
 * @property selvinortiz\hangouts\services\HangoutsService $service
 */
class Hangouts extends Plugin
{

}


/**
 * @return Hangouts
 */
function hangouts()
{
    return Yii::$app->loadedModules[Hangouts::class] ?? null;
}
