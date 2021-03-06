<?php
/*
 * General Configuration
 *
 * All of your system's general configuration settings go in here. You can see a
 * list of the default settings in `vendor/craftcms/cms/src/config/defaults/general.php`.
 */

$config = [
    '*' => [
        'env' => '*',
        'devMode' => true,
        'siteUrl' => 'https://craftx.io',
        'sitePath' => dirname(__DIR__, 1).'/web',
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
        'autoLoginAfterAccountActivation' => false,
        #
        # Session Related
        'csrfTokenName' => 'X-CSRF-Token',
        'phpSessionName' => 'icqahkapdsqrmqnyazmrdqzyroqzrrrz',
        'userSessionDuration' => false,
        'rememberedUserSessionDuration' => 'P1M',
        'verificationCodeDuration' => 'P1D', // Very short
        #
        # Uploads
        'maxUploadFileSize' => 268435456, // 256M
        'allowedFileExtensions' => 'mp3,mp4,mov,mpeg,webm,jpg,jpeg,png,gif',
    ],
    'dev.' => [
        'env' => 'staging',
        'devMode' => true,
        'siteUrl' => 'https://dev.craftx.io'
    ]
];

$localConfigFile = __DIR__.'/local/general.php';

if (file_exists($localConfigFile)) {
    $localConfig = require($localConfigFile);

    return array_merge($config, is_array($localConfig) ? $localConfig : []);
}

return $config;
