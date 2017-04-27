<?php
namespace selvinortiz\hangouts\variables;

class HangoutsVariable
{
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
    public function translateDate(\DateTime $date)
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
