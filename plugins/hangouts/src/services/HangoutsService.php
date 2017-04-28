<?php
namespace selvinortiz\hangouts\services;

use Craft;
use craft\base\Component;
use craft\elements\Entry;

class HangoutsService extends Component
{
    /**
     * Default timezones to translate hangout date/time into
     */
    const TIMEZONES = [
        'America/Chicago',
        'America/Denver',
        'America/New_York',
        'America/Los_Angeles',
        'America/Sao_Paulo',
        'Canada/Saskatchewan',
        'Australia/Perth',
        'Australia/Sydney',
        'Europe/London',
        'Europe/Paris',
        'Asia/Tokyo',
        'Asia/Dubai',
        'Asia/Singapore',
    ];

    /**
     * Method mapping to use in HangoutsExtension and expose to templates
     */
    const EXTENSION_METHODS = [
        'generateSummary' => 'generateSummary',
        'getHangoutStatus' => 'getHangoutStatus',
        'translateDateTime' => 'translateDateTime',
        'isPastHangout' => 'isPastHangout',
        'isOngoingHangout' => 'isOngoingHangout',
        'isUpcomingHangout' => 'isUpcomingHangout',
    ];

    /**
     * Default duration for hangouts
     */
    const HANGOUT_DEFAULT_DURATION = '2 hours';

    /**
     * Default status for hangouts
     */
    const HANGOUT_STATUS_UPCOMING = 'upcoming';
    const HANGOUT_STATUS_ONGOING = 'ongoing';
    const HANGOUT_STATUS_ENDED = 'ended';

    /**
     * Hangout date/time field handle used in hangout entries
     */
    const HANGOUT_DATETIME_FIELD_HANDLE = 'hangoutDateTime';

    public function getExtensionMethods()
    {
        return self::EXTENSION_METHODS;
    }

    /**
     * @param Entry  $hangout
     * @param string $duration
     *
     * @return string
     */
    public function getHangoutStatus(Entry $hangout, $duration = self::HANGOUT_DEFAULT_DURATION): string
    {
        $currentDateTime = new \DateTime('now', new \DateTimeZone(Craft::$app->timeZone));
        $hangoutDateTime = $hangout->hangoutDateTime;
        $hangoutDateTimePlusDuration = (clone $hangoutDateTime)->modify(sprintf('+%s', $duration));

        if ($currentDateTime > $hangoutDateTime && $currentDateTime < $hangoutDateTimePlusDuration) {
            return self::HANGOUT_STATUS_ONGOING;
        }

        if ($hangoutDateTimePlusDuration > $currentDateTime) {
            return self::HANGOUT_STATUS_UPCOMING;
        }

        return self::HANGOUT_STATUS_ENDED;
    }

    public function isOngoingHangout(Entry $hangout)
    {
        return $this->getHangoutStatus($hangout) === self::HANGOUT_STATUS_ONGOING;
    }

    public function isUpcomingHangout(Entry $hangout)
    {
        return $this->getHangoutStatus($hangout) === self::HANGOUT_STATUS_UPCOMING;
    }

    public function isPastHangout(Entry $hangout)
    {
        return $this->getHangoutStatus($hangout) === self::HANGOUT_STATUS_ENDED;
    }

    /**
     * @param string $text  Can be an object that implements __toString()
     * @param int    $limit
     * @param string $break
     * @param string $pad
     *
     * @return bool|string
     */
    public function generateSummary($text, $limit = 160, $break = ' ', $pad = '...')
    {
        $text = strip_tags($text);

        // return with no change if string is shorter than $limit
        if (strlen($text) <= $limit) {
            return $text;
        }

        $text = substr($text, 0, $limit);

        if (false !== ($breakpoint = strrpos($text, $break))) {
            $text = substr($text, 0, $breakpoint);
        }

        return $text.$pad;
    }

    /**
     * @return \DateTime[]
     */
    public function translateDateTime(\DateTime $date)
    {
        $dates = [];

        foreach (self::TIMEZONES as $timezone)
        {
            $newDate = clone($date);
            $newDate->setTimezone(new \DateTimeZone($timezone));

            $dates[] = $newDate;
        }

        return $dates;
    }
}
