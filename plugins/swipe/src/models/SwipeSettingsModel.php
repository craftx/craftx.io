<?php
namespace selvinortiz\swipe\models;

use craft\base\Model;

class SwipeSettingsModel extends Model {
    /**
     * @var string User supplied name for the plugin
     */
    public $nickname;

    /**
     * @var string
     */
    public $stripeSecretKey;

    /**
     * @var string
     */
    public $stripePublicKey;

    /**
     * @var string
     */
    public $usernameBlacklist = ['admin'];

    public function rules(): array {
        return [
            [['stripeSecretKey', 'stripePublicKey'], 'required'],
        ];
    }
}
