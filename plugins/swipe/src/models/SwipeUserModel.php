<?php
namespace selvinortiz\swipe\models;

use function selvinortiz\swipe\swipe;

use Craft;
use craft\base\Model;

class SwipeUserModel extends Model {

    /**
    * @var String
    */
    public $username;

    /**
    * @var String
    */
    public $email;

    public function rules() {

        return [

            // Character and blacklist validation of username
            [ ['username', 'email'], 'required'],

            // Make sure email is valid
            ['email', 'email', 'message' => 'Please enter a valid email address'],

            // Make sure username is between 5 and 25 characters
            [
                'username',
                'string',
                'min'       => 5,
                'max'       => 25,
                'tooShort'  => 'Username must be at least 5 characters long',
                'tooLong'   => 'Username must be less than 25 characters'
            ],

            // Check if username contains proper characters
            [ 'username', 'usernameCharacterCheck' ],

            // Make sure username is not blacklisted
            [ 'username', 'usernameBlacklistCheck' ],

            // Make sure the username or email are not already taken.
            [ ['email', 'username'], 'checkAvailability' ]
        ];
    }

    /**
    * Make sure the username only uses the acceptable parameters
    *
    * @param string $attribute the attribute currently being validated
    * @param mixed $params the value of the "params" given in the rule
    * @param \yii\validators\InlineValidator related InlineValidator instance.
    * This parameter is available since version 2.0.11.
    */
    public function usernameCharacterCheck($attribute, $params, $validator) {
        // Only letters, numbers, and hyphens
        if ( !preg_match('/^[a-zA-Z\d\-]*$/', $this->$attribute) ) {
            $this->addError($attribute,
            'Username must only contain letters, numbers, and hyphens');
        }

        // Must contain at least one letter
        if ( !preg_match('/[a-zA-Z]+/', $this->$attribute) ) {
            $this->addError($attribute,
            'Username must contain at least one letter');
        }
    }

    /**
    * Check to see if username is blacklisted
    */
    public function usernameBlacklistCheck($attribute, $params, $validator) {

        // Get the username blacklist from settings
        $usernameBlacklist = swipe()->api->settings()->usernameBlacklist;

        // Check against local blacklist
        if ( in_array($this->$attribute, $usernameBlacklist) ) {
            $this->addError($attribute,
            'Sorry, that username is blacklisted, please choose another');
        }
    }

    /**
    * Check to see if the username or email already exists
    */
    public function checkAvailability($attribute, $params, $validator) {

        $errorMessage = 'That ' . $attribute . ' is already taken';

        if ( Craft::$app->users->getUserByUsernameOrEmail($this->$attribute) ) {
            $this->addError($attribute, $errorMessage);
        }
    }
}
