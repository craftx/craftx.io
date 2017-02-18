<?php

namespace selvinortiz\swipe\controllers;

use Craft;
use craft\elements\User;
use craft\helpers\ElementHelper;
use craft\web\Controller;

use selvinortiz\swipe\models\SwipePlanModel;
use function selvinortiz\swipe\swipe;
use yii\log\Logger;

class SwipePlansController extends Controller {
    protected $allowAnonymous = ['actionSubscribe'];

    public function actionEdit(string $id = '') {
        $this->requireAdmin();

        $plan = swipe()->plans->one($id);

        return $this->renderTemplate('swipe/plans/_edit', compact('id', 'plan'));
    }

    public function actionSave() {
        $this->requireAdmin();
        $this->requirePostRequest();

        $plan = new SwipePlanModel([
            'id' => Craft::$app->request->getBodyParam('id'),
            'name' => Craft::$app->request->getBodyParam('name'),
            'amount' => Craft::$app->request->getBodyParam('amount'),
        ]);

        if (swipe()->plans->savePlan($plan)) {
            Craft::$app->session->setNotice('Plan Saved');

            return $this->redirectToPostedUrl($plan);
        }
    }

    public function actionSubscribe() {
        $this->requirePostRequest();
        $this->requireAcceptsJson();

        $name = swipe()->api->getDecodedParam('args.billing_name');
        $token = swipe()->api->getDecodedParam('token.id');
        $email = swipe()->api->getDecodedParam('token.email');
        $customer = swipe()->api->createCustomer($email, $token);
        $subscription = swipe()->api->createSubscription($customer->id, 'developer-monthly-plan');

        $user = new User();
        $user->email = $customer->email;
        $user->username = ElementHelper::createSlug($user->email);
        $user->firstName = $this->getFirstName($name);
        $user->lastName = $this->getLastName($name);

        try {
            $user->setFieldValues([
                'customerId' => $customer->id,
                'subscriptionId' => $subscription->id,
                'subscriptionJson' => Craft::$app->request->getRawBody(),
                'billingEmail' => $email,
                'billingCountry' => swipe()->api->getDecodedParam('args.billing_country'),
                'billingCountryCode' => swipe()->api->getDecodedParam('args.billing_country_code'),
                'billingAddress' => swipe()->api->getDecodedParam('args.billing_line1'),
                'billingCity' => swipe()->api->getDecodedParam('args.billing_city'),
                'billingState' => swipe()->api->getDecodedParam('args.billing_state'),
                'billingZip' => swipe()->api->getDecodedParam('args.billing_zip'),
            ]);
        } catch (\Exception $exception) {

            swipe()->api->error($exception);

            return $this->asErrorJson($exception->getMessage());
        }

        if (($currentUser = Craft::$app->users->getUserByEmail($email))) {
            $message = Craft::t('User with {email}, already exists.', compact('email'));
            swipe()->api->error($message);

            return $this->asErrorJson($message);
        }

        if (!Craft::$app->elements->saveElement($user)) {
            swipe()->api->error($user->getErrors());

            return $this->asErrorJson('Unable to create user account');
        }

        if (!Craft::$app->users->sendActivationEmail($user)) {

            $message = 'Unable to send activation email';

            swipe()->api->error($message);

            return $this->asErrorJson($message);
        }

        Craft::$app->user->loginByUserId($user->id);

        $success = true;
        $message = 'You have been subscribed.';

        return $this->asJson(compact($success, $message));
    }

    public function getFirstName(string $name) {
        if (!empty($name)) {
            $name = explode(' ', $name);

            return trim(array_shift($name));
        }
    }

    public function getLastName(string $name) {
        if (!empty($name)) {
            $name = explode(' ', $name);
            array_shift($name);

            return trim(implode(' ', $name));
        }
    }
}
