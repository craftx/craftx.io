<?php
namespace selvinortiz\hangouts\variables;

class HangoutsVariable
{
    const TIMEZONES = [
        'America/Chicago',
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
