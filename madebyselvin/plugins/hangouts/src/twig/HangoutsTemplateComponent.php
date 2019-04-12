<?php
namespace selvinortiz\hangouts\twig;

use function selvinortiz\hangouts\hangouts;

/**
 * Class HangoutsTemplateComponent
 *
 * @package selvinortiz\hangouts\twig
 */
class HangoutsTemplateComponent
{
    /**
     * Allows component to act as proxy into the HangoutsService
     *
     * @param string $method
     * @param array  $arguments
     *
     * @return mixed
     */
    public function __call(string $method, array $arguments = []) {
        if (method_exists(hangouts()->service, $method)) {
            return call_user_func_array([hangouts()->service, $method], $arguments);
        }
    }
}
