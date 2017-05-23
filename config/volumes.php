<?php

$baseUrl = 'https://craftx.io/assets/';
$basePath = dirname(__DIR__, 1).'/web/assets/';

return [
    // Production
    '*' => [
        'blog' => [
            'url' => $baseUrl.'blog/',
            'path' => $basePath.'blog/'
        ],
        'hangouts' => [
            'url' => $baseUrl.'hangouts/',
            'path' => $basePath.'hangouts/'
        ],
        'people' => [
            'url' => $baseUrl.'people/',
            'path' => $basePath.'people/'
        ]
    ],
    // Staging
    'dev.' => [
        'blog' => [
            'url' => $baseUrl.'blog/',
            'path' => $basePath.'blog/'
        ],
        'hangouts' => [
            'url' => $baseUrl.'hangouts/',
            'path' => $basePath.'hangouts/'
        ],
        'people' => [
            'url' => $baseUrl.'people/',
            'path' => $basePath.'people/'
        ]
    ],
    // Local
    '.dev' => [
        'blog' => [
            'url' => $baseUrl.'blog/',
            'path' => $basePath.'blog/'
        ],
        'hangouts' => [
            'url' => $baseUrl.'hangouts/',
            'path' => $basePath.'hangouts/'
        ],
        'people' => [
            'url' => $baseUrl.'people/',
            'path' => $basePath.'people/'
        ]
    ]
];
