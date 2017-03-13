<?php
namespace selvinortiz\swipe\controllers;


use yii\helpers\Json;
use GuzzleHttp\Client;

use Craft;
use craft\web\Controller;

use function selvinortiz\swipe\swipe;

class SwipeNewsletterController extends Controller
{
    const SUBSCRIBE_URL = 'https://hall.craftx.io/subscribe';
    const SUBSCRIBER_LIST_ID = 'f763pUfU0rlIkJ76892UwO518A';

    protected $allowAnonymous = ['actionSubscribe'];

    private $_alreadySubscribedError = 'Already subscribed.';
    private $_alreadySubscribedMessage = 'Looks like you should already be getting my newsletter.';
    private $_errorResponses = [
        'Invalid list ID.' => [
            'title' => 'Shoot!',
            'message' => 'Looks like I screwed up setting up a list ID.',
        ],
        'Invalid email address' => [
            'title' => 'Hey!',
            'message' => 'Looks like you are trying to trick me with that email.',
        ],
        'Some fields are missing.' => [
            'title' => 'Oh boy!',
            'message' => 'Looks like I screwed something up with required fields',
        ]
    ];

    public function actionSubscribe()
    {
        $this->requirePostRequest();
        $this->requireAcceptsJson();

        $email = swipe()->api->getDecodedParam('email');

        if (!$email || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
            return $this->asJson([
                'title' => 'Hey!',
                'message' => 'Looks like you need to provide a valid email address.',
                'success' => false,
                'params' => compact('email')
            ]);
        }

        $response = $this->subscribe($email);

        return $this->asJson([
            'title' => $response['title'],
            'message' => $response['message'],
            'success' => $response['success'],
            'params' => compact('email')
        ]);
    }

    protected function subscribe(string $email)
    {
        $client = new Client();
        $fields = [
            'list' => self::SUBSCRIBER_LIST_ID,
            'name' => '',
            'email' => $email,
            'boolean' => 'true',
        ];

        $response = $client->post(self::SUBSCRIBE_URL, ['form_params' => $fields]);
        $responseBody = (string)$response->getBody();

        if (array_key_exists($responseBody, $this->_errorResponses)) {
            $title = $this->_errorResponses[$responseBody]['title'];
            $message = $this->_errorResponses[$responseBody]['message'];
            $success = false;
        } elseif ($responseBody == $this->_alreadySubscribedError) {
            $title = 'Done!';
            $message = $this->_alreadySubscribedMessage;
            $success = true;
        } else {
            $title = 'One more step!';
            $message = 'A confirmation email should be on its way to {email} ;)';
            $success = true;
        }

        return compact('title', 'message', 'success');
    }
}
