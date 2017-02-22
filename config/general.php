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
        'cpTrigger' => 'studio',
        'defaultWeekStartDay' => 0, // 0 = Sunday, 1 = Monday
        'enableCsrfProtection' => true,
        'omitScriptNameInUrls' => true,
        'maxSlugIncrement' => 10,
        'sendPoweredByHeader' => false,
        'testToEmailAddress' => 'selvin@craftx.io',
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
        'setPasswordPath' => 'reset/your/password',
        'setPasswordSuccessPath' => 'your/password/was/reset',
        'activateAccountSuccessPath' => 'your/account/was/activated',
        'invalidUserTokenPath' => 'your/token/is/invalid',
        'postLoginRedirect' => '@{username}',
        'limitAutoSlugsToAscii' => true,
        'maxInvalidLogins' => 3,
        #
        # Session Related
        'csrfTokenName' => 'X-CSRF-Token',
        'phpSessionName' => 'icqahkapdsqrmqnyazmrdqzyroqzrrrz',
        'userSessionDuration' => false,
        'rememberedUserSessionDuration' => 'P1M',
        'verificationCodeDuration' => 'PT1H', // Very short
        #
        # Uploads
        'maxUploadFileSize' => 16777216, // @todo Revisit this and update as necessary
        'allowedFileExtensions' => 'mp3,mp4,mov,mpeg,webm,jpg,jpeg,png,gif',
    ],
    '.dev' => [
        'env' => 'dev',
        'siteUrl' => 'http://craftx.dev',
        'devMode' => true,
        'translationDebugOutput' => true,
        'cacheDuration' => 'PT1M'
    ]
];
