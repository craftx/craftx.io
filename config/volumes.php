<?php
return [
    // Production
    '*' => [
        'blog' => [
            'url' => 'https://craftx.io/assets/blog/',
            'path' => dirname(__DIR__, 1).'/web/assets/blog/'
        ],
        'hangouts' => [
            'url' => 'https://craftx.io/assets/hangouts/',
            'path' => dirname(__DIR__, 1).'/web/assets/hangouts/'
        ],
    ],
    // Staging
    'dev.' => [
        'blog' => [
            'url' => 'https://dev.craftx.io/assets/blog/',
            'path' => dirname(__DIR__, 1).'/web/assets/blog/'
        ],
        'hangouts' => [
            'url' => 'https://dev.craftx.io/assets/hangouts/',
            'path' => dirname(__DIR__, 1).'/web/assets/hangouts/'
        ],
    ],
    // Local
    '.dev' => [
        'blog' => [
            'url' => 'http://craftx.dev/assets/blog/',
            'path' => dirname(__DIR__, 1).'/web/assets/blog/'
        ],
        'hangouts' => [
            'url' => 'http://craftx.dev/assets/hangouts/',
            'path' => dirname(__DIR__, 1).'/web/assets/hangouts/'
        ],
    ]
];
