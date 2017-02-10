<?php
namespace selvinortiz\swipe\controllers;

use Craft;
use craft\web\Controller;

use selvinortiz\swipe\models\SwipePlanModel;
use function selvinortiz\swipe\swipe;

class SwipePlansController extends Controller {

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
}
