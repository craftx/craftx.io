<?php
return [
    // Production
    '*' => [
        'hangouts' => [
            'url' => 'https://craftx.io/assets/hangouts/',
            'path' => dirname(__DIR__, 1).'/web/assets/hangouts/'
        ]
    ],
    // Staging
    'dev.' => [
        'hangouts' => [
            'url' => 'https://dev.craftx.io/assets/hangouts/',
            'path' => dirname(__DIR__, 1).'/web/assets/hangouts/'
        ]
    ],
    // Local
    '.dev' => [
        'hangouts' => [
            'url' => 'http://craftx.dev/assets/hangouts/',
            'path' => dirname(__DIR__, 1).'/web/assets/hangouts/'
        ]
    ]
];
