<?php
/*
 * General Configuration
 *
 * All of your system's general configuration settings go in here. You can see a
 * list of the default settings in `vendor/craftcms/cms/src/config/defaults/general.php`.
 */

return [
    '*' => [
        'env' => '*',
        'devMode' => false,
        'siteUrl' => 'https://craftx.io',
        'sitePath' => __DIR__.'/../web/',
        'cpTrigger' => 'studio',
        'defaultWeekStartDay' => 0, // 0 = Sunday, 1 = Monday
        'enableCsrfProtection' => true,
        'omitScriptNameInUrls' => true,
        'maxSlugIncrement' => 10,
        'sendPoweredByHeader' => false,
        'timezone' => 'America/Chicago',
        'usePathInfo' => true,
        'convertFilenamesToAscii' => true,
        'cacheDuration' => 'P1Y',
        'generateTransformsBeforePageLoad' => true,
        'imageDriver' => 'imagick',
        #
        # CP Resources
        'resourceBasePath' => '@webroot/cpr',
        'resourceBaseUrl' => '@web/cpr',
        'resourceTrigger' => 'cpr',
        #
        # User Routes
        'setPasswordPath' => 'v1/reset-your-password',
        'setPasswordSuccessPath' => 'v1/your-password-was-reset',
        'activateAccountSuccessPath' => 'v1/your-account-was-activated',
        'invalidUserTokenPath' => 'v1/your-token-is-invalid',
        'postLoginRedirect' => '@{username}',
        'limitAutoSlugsToAscii' => true,
        'maxInvalidLogins' => 3,
        'autoLoginAfterAccountActivation' => true,
        #
        # Session Related
        'csrfTokenName' => 'X-CSRF-Token',
        'phpSessionName' => 'icqahkapdsqrmqnyazmrdqzyroqzrrrz',
        'userSessionDuration' => false,
        'rememberedUserSessionDuration' => 'P1M',
        'verificationCodeDuration' => 'P1D', // Very short
        #
        # Uploads
        'maxUploadFileSize' => 16777216, // @todo Revisit this and update as necessary
        'allowedFileExtensions' => 'mp3,mp4,mov,mpeg,webm,jpg,jpeg,png,gif',
    ],
    'dev.' => [
        'env' => 'staging',
        'devMode' => true,
        'siteUrl' => 'https://dev.craftx.io'
    ],
    '.dev' => [
        'env' => 'dev',
        'siteUrl' => 'http://craftx.dev',
        'devMode' => true,
        'translationDebugOutput' => false,
    ]
];
