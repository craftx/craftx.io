<?php
namespace selvinortiz\hangouts\twig;

use function selvinortiz\hangouts\hangouts;

class HangoutsExtension extends \Twig_Extension
{
    /**
     * @return array
     */
    public function getFilters()
    {
        $filters = [];
        $service = hangouts()->service;

        foreach ($service->getExtensionMethods() as $name => $method) {
            $filters[] = new \Twig_SimpleFilter($name, [$service, $method]);
        }

        return $filters;
    }

    /**
     * @return array
     */
    public function getFunctions()
    {
        $functions = [];
        $service = hangouts()->service;

        foreach ($service->getExtensionMethods() as $name => $method) {
            $functions[] = new \Twig_SimpleFunction($name, [$service, $method]);
        }

        return $functions;
    }
}
