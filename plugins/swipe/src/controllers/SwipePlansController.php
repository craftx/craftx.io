<?php
namespace selvinortiz\swipe\controllers;

use Craft;
use craft\elements\User;
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

        $token = swipe()->api->getDecodedParam('token.id');
        $email = swipe()->api->getDecodedParam('token.email');
        $customer = swipe()->api->createCustomer($email, $token);
        $subscription = swipe()->api->createSubscription($customer->id, 'developer-monthly-plan');

        $user = $this->createUser($customer);
        return $this->asJson($subscription);
    }

    public function createUser($customer) {
        $user = new User();
        $user->email = $customer->email;
        $user->setFieldValue('billingId', $customer->id);

        // @todo: More:)
    }
}
