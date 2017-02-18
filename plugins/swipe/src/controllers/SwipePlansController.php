<?php
namespace selvinortiz\swipe\controllers;

use Craft;
use craft\elements\User;
use craft\helpers\ElementHelper;
use craft\web\Controller;

use Imagine\Filter\Basic\Strip;
use selvinortiz\swipe\models\SwipePlanModel;
use function selvinortiz\swipe\swipe;

class SwipePlansController extends Controller
{
    protected $allowAnonymous = ['actionSubscribe'];

    public function actionEdit(string $id = '')
    {
        $this->requireAdmin();

        $plan = swipe()->plans->one($id);

        return $this->renderTemplate('swipe/plans/_edit', compact('id', 'plan'));
    }

    public function actionSave()
    {
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

    public function actionSubscribe()
    {
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
        $user->setFieldValue('customerId', $customer->id);
        $user->setFieldValue('subscriptionId', $subscription->id);
        $user->setFieldValue('subscriptionJson', Craft::$app->request->getRawBody());

        if (! Craft::$app->elements->saveElement($user)) {
            Craft::dd($user->getErrors());
        }

        Craft::dd([$user, $customer, $subscription, swipe()->api->getDecodedParams()]);
        return $this->asJson($subscription);
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
