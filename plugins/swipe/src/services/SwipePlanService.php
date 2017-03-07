<?php
namespace selvinortiz\swipe\services;

use Stripe\Plan;
use Stripe\Stripe;

use craft\base\Component;
use craft\helpers\ElementHelper;

use function selvinortiz\swipe\swipe;
use selvinortiz\swipe\models\SwipePlanModel;

class SwipePlanService extends Component {

    public function init()
    {
        Stripe::setApiKey(swipe()->api->settings()->stripeSecretKey);
    }

    public function one(string $id = '')
    {
        if (empty($id) || !($plan = Plan::retrieve($id))) {
            return new SwipePlanModel();
        }

        return new SwipePlanModel([
            'id' => $plan->id,
            'name' => $plan->name,
            'amount' => $plan->amount,
            'currency' => $plan->currency,
            'interval' => $plan->interval,
            'intervalCount' => $plan->interval_count,
            'statementDescription' => $plan->statement_descriptor,
        ]);
    }

    public function all(): array
    {
        $plans = Plan::all();

        if (empty($plans) || !($plans = $plans->data)) {
            return [];
        }

        $models = [];

        foreach ($plans as $plan) {
            $models[] = new SwipePlanModel([
                'id' => $plan->id,
                'name' => $plan->name,
                'amount' => $plan->amount,
                'currency' => $plan->currency,
                'interval' => $plan->interval,
                'intervalCount' => $plan->interval_count
            ]);
        }

        return $models;
    }

    public function savePlan(SwipePlanModel $plan): bool
    {
        if (!$plan->id) {
            $plan->id = $this->_nameToId($plan->name);
        }

        return (bool)Plan::create([
            'id' => $plan->id,
            'name' => $plan->name,
            'amount' => $plan->amount,
            'currency' => $plan->currency,
            'interval' => $plan->interval,
            'interval_count' => $plan->intervalCount,
        ]);
    }

    public function createSubscription($user) {
        $user;
    }

    private function _nameToId($name)
    {
        // createSlug() could return lower and uppercase depending on settings
        return mb_strtolower(ElementHelper::createSlug($name));
    }
}
