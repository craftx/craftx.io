<?php
namespace selvinortiz\hangouts\controllers;

use Craft;
use craft\helpers\Json;
use craft\web\Controller;
use craft\elements\Entry;
use craft\elements\db\EntryQuery;

class HangoutsController extends Controller
{
    protected $allowAnonymous = [
        'next',
        'get-date-time-data'
    ];

    private $_decodedParams;

    public function actionGetDateTimeData()
    {
        $this->requireAcceptsJson();

        $response = [
            'success' => false,
        ];

        $sourceDateTime = $this->getDecodedParam('sourceDateTime');
        $destinationTimeZone = $this->getDecodedParam('destinationTimeZone');

        if ($sourceDateTime && $destinationTimeZone)
        {
            try {
                $date = new \DateTime($sourceDateTime, new \DateTimeZone(Craft::$app->timezone));

                $date->setTimeZone(new \DateTimeZone($destinationTimeZone));

                $response['day'] = $date->format('l');
                $response['time'] = $date->format('g:i A');
                $response['date'] = $date->format('j F Y');
                $response['zoneIdentifier'] = $date->format('e');
                $response['zoneAbbreviation'] = $date->format('(T)');
                $response['success'] = true;
            } catch (\Exception $e) {
                $response['date'] = $sourceDateTime;
                $response['zone'] = $destinationTimeZone;
                Craft::error($e->getMessage(), __METHOD__);
            }
        }

        return $this->asJson($response);
    }

    public function actionNext()
    {
        $now = new \DateTime('now', new \DateTimeZone('America/Chicago'));
        $query = new EntryQuery(Entry::class);
        $query->limit = 1;
        $query->section = 'hangouts';
        $query->orderBy = 'hangoutDateTime asc';
        $query->hangoutDateTime = sprintf('> %s', $now->format('Y-m-d H:i'));

        $hangout = $query->one();

        $this->redirect($hangout->url ?? '/hangouts?from=next');
    }

    private function getDecodedParams($default = [])
    {
        if (null === $this->_decodedParams) {
            $this->_decodedParams = Json::decode(Craft::$app->request->getRawBody());
        }

        return $this->_decodedParams ?? $default;
    }

    private function getDecodedParam(string $name, $default = null)
    {
        if (null === $this->_decodedParams) {
            $this->_decodedParams = Json::decode(Craft::$app->request->getRawBody());
        }

        return $this->_decodedParams[$name] ??  $default;
    }

}
