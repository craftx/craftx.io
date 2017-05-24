<?php
namespace selvinortiz\hangouts\services;

use Jsvrcek\ICS\Model\Calendar;
use Jsvrcek\ICS\Model\CalendarEvent;
use Jsvrcek\ICS\Model\Relationship\Attendee;
use Jsvrcek\ICS\Model\Relationship\Organizer;
use Jsvrcek\ICS\Utility\Formatter;
use Jsvrcek\ICS\CalendarStream;
use Jsvrcek\ICS\CalendarExport;

use Craft;
use craft\web\Response;
use craft\base\Component;
use craft\elements\Entry;

use function selvinortiz\hangouts\hangouts;

use selvinortiz\hangouts\common\HangoutsCalendarExporter;

class HangoutsCalendarService extends Component
{
    const ORGANIZER_NAME   = 'Selvin Ortiz';
    const ORGANIZER_EMAIL  = 'selvin@craftx.io';
    const HANGOUT_DURATION = '+1 hour';
    const SPECIAL_GUEST_EMAIL = 'guests@craftx.io';

    /**
     * @var Calendar
     */
    private $calendar;

    /**
     * @var CalendarEvent[]
     */
    private $events = [];

    public function init()
    {
        $this->calendar = (new Calendar())
            ->setProdId('-//CraftX//Hangouts//EN')
            ->setTimezone(new \DateTimeZone(Craft::$app->timeZone))
            ->setCustomHeaders(['X-WR-CALNAME' => 'CraftX']);
    }

    /**
     * @param Entry $hangout
     */
    public function addEvent(Entry $hangout)
    {
        $this->events[] = $this->makeEvent($hangout);

        return $this;
    }

    /**
     * @param Entry[] $hangouts
     *
     * @return $this
     */
    public function addEvents(array $hangouts)
    {
        foreach ($hangouts as $hangout)
        {
            $this->addEvent($hangout);
        }

        return $this;
    }

    /**
     * @return string
     */
    public function sendToBrowser()
    {
        $response = new Response();
        $headers  = $response->headers;

        $headers->set('Content-Type', 'text/calendar; charset=utf-8');

        $response->content = $this->render();

        return $response;
    }

    /**
     * @return string
     */
    public function sendToDownload()
    {
        $response = new Response();
        $headers  = $response->headers;

        $headers->set('Content-Type', 'text/calendar; charset=utf-8');

        return $response->sendContentAsFile($this->render(), $this->generateFilename());
    }

    /**
     * @param Entry $hangout
     *
     * @return CalendarEvent
     */
    private function makeEvent(Entry $hangout)
    {
        $host = (new Organizer(new Formatter()))
            ->setValue(self::ORGANIZER_EMAIL)
            ->setName(self::ORGANIZER_NAME)
            ->setSentBy(self::ORGANIZER_EMAIL)
            ->setLanguage('en');

        $event = (new CalendarEvent())
            ->setUrl($hangout->getUrl())
            ->setStart($hangout->hangoutDateTime)
            ->setEnd((clone $hangout->hangoutDateTime)->modify(self::HANGOUT_DURATION))
            ->setSummary($hangout->title)
            ->setDescription($this->generateDescription($hangout))
            ->setUid('craftx-hangout-'.$hangout->slug)
            ->setPriority(5)
            ->setStatus('CONFIRMED')
            ->setLastModified(new \DateTime('now', new \DateTimeZone('America/Chicago')))
            ->setOrganizer($host);

        if (($hangoutGuest = $hangout->hangoutGuest->one()))
        {
            $guest = (new Attendee(new Formatter()))
                ->setValue(self::SPECIAL_GUEST_EMAIL)
                ->setName(implode(' ', [$hangoutGuest->firstName, $hangoutGuest->lastName]));

            $event->addAttendee($guest);
        }

        return $event;
    }

    /**
     * @return string
     */
    private function generateFilename()
    {
        /**
         * @var CalendarEvent $event
         */
        if (count($this->events) > 1)
        {
            return 'craftx-hangouts.ics';
        }

        $events = $this->events;
        $event  = array_shift($events);

        return $event->getUid().'.ics';
    }

    private function generateDescription(Entry $hangout)
    {
        $description = hangouts()->service->generateSummary($hangout->hangoutTopic, 255, '', '...');

        $break = PHP_EOL.PHP_EOL;

        return "{$description}{$break}Join via {$hangout->hangoutLink}";
    }

    /**
     * @return string
     */
    private function render()
    {
        foreach ($this->events as $event)
        {
            $this->calendar->addEvent($event);
        }

        return (new HangoutsCalendarExporter(new CalendarStream(), new Formatter()))
            ->addCalendar($this->calendar)
            ->getStream();
    }
}
