<?php
namespace selvinortiz\hangouts\models;

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

class HangoutsEvent extends Model
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

        $this->guest = (new Attendee(new Formatter()))
            ->setValue('support@craftx.io')
            ->setName('Gary Hockin');

        $this->event = (new CalendarEvent())
            ->setUrl($hangout->hangoutLink)
            ->setStart($hangout->hangoutDateTime)
            ->setEnd((clone $hangout->hangoutDateTime)->modify('+1 hour'))
            ->setSummary($hangout->title)
            ->setDescription(hangouts()->service->generateSummary($hangout->hangoutTopic->getHtml(), 160, ' ', '... ' . $hangout->getUrl()))
            ->setUid(base64_encode($hangout->id))
            ->setOrganizer($this->host)
            ->addAttendee($this->guest);

        $this->calendar = (new Calendar())
            ->setProdId('-//CraftX//Hangouts//EN')
            ->addEvent($this->event);

        return $this;
    }

    public function render()
    {
        $export = new CalendarExport(new CalendarStream(), new Formatter());
        $export->addCalendar($this->calendar);

        echo '<pre>', $export->getStream(), '</pre>'; exit;
    }
}
