<?php
namespace selvinortiz\hangouts;

use craft\base\Plugin;

use selvinortiz\hangouts\variables\HangoutsVariable;

/**
 * Class Hangouts
 *
 * @package selvinortiz\hangouts
 *
 * @property selvinortiz\hangouts\services\HangoutsService $service
 */
class Hangouts extends Plugin
{
    public function defineTemplateComponent()
    {
        return HangoutsVariable::class;
    }

}


/**
 * @return Hangouts
 */
function hangouts()
{
    return Yii::$app->loadedModules[Hangouts::class] ?? null;
}
