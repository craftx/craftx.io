<?php
namespace selvinortiz\swipe\services;

use Craft;
use craft\base\Component;
use craft\helpers\Json;

use Stripe\Charge;
use Stripe\Stripe;
use Stripe\Customer;

use SelvinOrtiz\Dot\Dot;

use function selvinortiz\swipe\swipe;
use Stripe\Subscription;
use yii\log\Logger;

class SwipeService extends Component
{
    private $_decodedParams = null;

    public function init()
    {
        Stripe::setApiKey($this->settings()->stripeSecretKey);
    }

    /**
     * @param string $email  Email used at checkout
     * @param string $source Most likely the token generated by Stripe Checkout
     *
     * @return Customer
     */
    public function createCustomer(string $email, string $source)
    {
        return Customer::create(compact('email', 'source'));
    }

    public function createCharge(int $customer, int $amount, string $currency = 'usd'): Charge
    {
        return Charge::create(compact('customer', 'amount', 'currency'));
    }

    public function createSubscription(string $customer, string $plan): Subscription
    {
        return Subscription::create(compact('customer', 'plan'));
    }

    public function settings()
    {
        return swipe()->getSettings();
    }

    public function getPostLoginRedirect($identity)
    {
        return Craft::$app->view->renderObjectTemplate(
            Craft::$app->config->general->postLoginRedirect,
            [
                'email' => $identity->email,
                'username' => $identity->username,
            ]
        );
    }

    public function getDecodedParams($default = [])
    {
        if (null === $this->_decodedParams) {
            $this->_decodedParams = Json::decode(Craft::$app->request->getRawBody());
        }

        return $this->_decodedParams ?? $default;
    }

    public function getDecodedParam(string $name, $default = null)
    {
        if (null === $this->_decodedParams) {
            $this->_decodedParams = Json::decode(Craft::$app->request->getRawBody());
        }

        return Dot::get($this->_decodedParams, $name, $default);
    }

    /**
     * @param string $email
     * @param int    $size
     *
     * @source https://gravatar.com/site/implement/images/php/
     *
     * @return string
     */
    public function getGravatar(string $email, $size = 96)
    {
        return "https://www.gravatar.com/avatar/{$this->hash($email)}?s={$size}&d=mm&r=g";
    }

    public function error($message, array $vars = [])
    {
        $message = is_array($message) ? Craft::t(print_r($message, true), $vars) : $message;

        Craft::getLogger()->log($message, Logger::LEVEL_ERROR, 'swipe');
    }

    /**
     * @param string $str
     *
     * @return string
     */
    private function hash(string $str): string
    {
        return md5(strtolower(trim($str)));
    }
}
