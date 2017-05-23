<?php
namespace selvinortiz\hangouts\models;

use Craft;
use craft\base\Model;
use craft\elements\Entry;

use Jsvrcek\ICS\Model\Calendar;
use Jsvrcek\ICS\Model\CalendarEvent;
use Jsvrcek\ICS\Model\Relationship\Attendee;
use Jsvrcek\ICS\Model\Relationship\Organizer;
use Jsvrcek\ICS\Utility\Formatter;
use Jsvrcek\ICS\CalendarStream;
use Jsvrcek\ICS\CalendarExport;

use function selvinortiz\hangouts\hangouts;

class HangoutsCalendarEvent extends Model
{
    /**
     * @var Organizer
     */
    public $host;

    /**
     * @var CalendarEvent
     */
    public $event;

    /**
     * @var Attendee
     */
    public $guest;

    /**
     * @var Calendar
     */
    public $calendar;

    public function __construct(Entry $hangout)
    {
        $this->host = (new Organizer(new Formatter()))
            ->setValue('selvin@craftx.io')
            ->setName('Selvin Ortiz')
            ->setLanguage('en');

        if (($hangoutGuest = $hangout->hangoutGuest->one()))
        {
            $this->guest = (new Attendee(new Formatter()))
                ->setName(implode(' ', [$hangoutGuest->firstName, $hangoutGuest->lastName]));
        }

        $this->event = (new CalendarEvent())
            ->setUrl($hangout->hangoutLink)
            ->setStart($hangout->hangoutDateTime)
            ->setEnd((clone $hangout->hangoutDateTime)->modify('+1 hour'))
            ->setSummary($hangout->title)
            ->setDescription(hangouts()->service->generateSummary($hangout->hangoutTopic->getHtml(), 160, ' ', '... '.$hangout->getUrl()))
            ->setUid(sprintf('craftx-hangout-%s', $hangout->slug))
            ->setOrganizer($this->host)
            ->addAttendee($this->guest);

        $this->calendar = (new Calendar())
            ->setProdId('-//CraftX//Hangouts//EN')
            ->setTimezone(new \DateTimeZone(Craft::$app->timeZone))
            ->addEvent($this->event);

        return $this;
    }

    public function render()
    {
        $export = new CalendarExport(new CalendarStream(), new Formatter());
        $export->addCalendar($this->calendar);

        return $export->getStream();
    }
}
