<?php
namespace selvinortiz\swipe\services;

use Craft;
use craft\web\View;
use craft\base\Component;

use Aws\CloudFront\CloudFrontClient;

class SwipeVideoService extends Component {
    const BASE_URL = 'https://d20c5t1dxoiuw3.cloudfront.net/';
    const SIGNING_KEY_PAIR_ID = 'APKAJIIOFF4XWWX4K5KQ';
    const EXPIRATION_TIME_IN_SECONDS = 3600; // 1hr

    /**
     * @var string Private key file path
     */
    private $_privateKeyFile;

    /**
     * @var CloudFrontClient
     */
    private $_cloudFrontClient;

    public function init() {
        parent::init();

        $this->_privateKeyFile = Craft::$app->path->getConfigPath().'/swipe.pem';

        $this->_cloudFrontClient = new CloudFrontClient([
            'region' => 'us-west-2',
            'version' => '2014-11-06'
        ]);
    }

    public function getSignedUrl(string $resource): string {
        $ip = $this->getClientIp();
        $resourceUrl = self::BASE_URL.$resource;

        $policyVars = [
            'resourceUrl' => $resourceUrl,
            'expirationTimestamp' => $this->getExpiration()
        ];

        if ($ip) {
            $policyVars['clientIp'] = $ip;
        }

        return $this->_cloudFrontClient->getSignedUrl([
            'url' => $resourceUrl,
            'private_key' => $this->_privateKeyFile,
            'key_pair_id' => self::SIGNING_KEY_PAIR_ID,
            'policy' => $this->renderTemplate($policyVars)
        ]);
    }

    /**
     * Renders a Swipe template even if request originates from the front end
     *
     * @param array $vars
     *
     * @return string
     */
    private function renderTemplate(array $vars = []): string {
        $mode = Craft::$app->view->getTemplateMode();

        Craft::$app->view->setTemplateMode(View::TEMPLATE_MODE_CP);

        $rendered = Craft::$app->view->renderTemplate('swipe/_special/policy', $vars);

        Craft::$app->view->setTemplateMode($mode);

        return $rendered;
    }

    private function getClientIp() {
        $ip = Craft::$app->config->general->env == 'dev' ? '50.188.56.107' : $_SERVER['REMOTE_ADDR'];

        return filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_IPV4);
    }

    private function getExpiration(): int {
        return time() + self::EXPIRATION_TIME_IN_SECONDS;
    }
}
