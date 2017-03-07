<?php

namespace selvinortiz\swipe\controllers;

use Craft;
use craft\elements\User;
use craft\records\UserGroup;
use craft\helpers\ElementHelper;
use craft\web\Controller;

use selvinortiz\swipe\models\SwipePlanModel;
use function selvinortiz\swipe\swipe;
use Stripe\Coupon;
use Stripe\Error\InvalidRequest;
use Stripe\Plan;

class SwipePlansController extends Controller {
    protected $allowAnonymous = [
        'action-sign-up',
        'action-get-coupon'
    ];

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

    public function actionGetCoupon()
    {
        $this->requireAcceptsJson();
        $success = false;
        $message = 'Sorry, coupon is invalid or expired';
        $coupon = swipe()->api->getDecodedParam('coupon');
        $plan = swipe()->api->getDecodedParam('plan');

        try {
            $coupon = Coupon::retrieve($coupon);
        } catch (InvalidRequest $invalidRequest) {
            $message = $invalidRequest->getMessage();
        }

        if ($coupon && $coupon->valid) {
            $success = true;
            $message = sprintf('Yes, %s%% Discount!', $coupon->percent_off);

            try {
                $plan = Plan::retrieve($plan);
                $message = sprintf('Nice, you are saving $%s!', ($plan->amount/(100/$coupon->percent_off)) / 100);
            } catch (InvalidRequest $invalidRequest) {}
        }

        return $this->asJson(compact('success', 'coupon', 'message'));
    }

    public function actionSignUp() {
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

        $success = false;
        $message = '';

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
            $message = $exception->getMessage();
            
            swipe()->api->error($message);

            return $this->asJson(compact('success', 'message'));
        }

        if (($currentUser = Craft::$app->users->getUserByEmail($email))) {
            $message = sprintf('User with email %s, already exists.', $email);

            swipe()->api->error($message);

            return $this->asJson(compact('success', 'message'));
        }

        if (!Craft::$app->elements->saveElement($user)) {
            $message = 'Unable to create user account';
            $errors  = $user->getErrors();

            $response = compact('success', 'message', 'errors');

            swipe()->api->error($response);

            return $this->asJson($response);
        }

        if (!Craft::$app->users->sendActivationEmail($user)) {

            $message = 'Unable to send activation email';
            $response = compact('success', 'message');

            swipe()->api->error($response);

            return $this->asErrorJson($response);
        }

        if (($group = UserGroup::findOne(['handle' => 'subscribed']))) {
            Craft::$app->users->assignUserToGroups($user->id, [$group->id]);
        }

        // Craft::$app->user->loginByUserId($user->id);

        $success = true;
        $message = 'You have been subscribed.';

        return $this->asJson(compact('success', 'message'));
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
