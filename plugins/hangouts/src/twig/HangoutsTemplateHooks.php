<?php
namespace selvinortiz\hangouts\twig;

use Craft;
use craft\elements\db\EntryQuery;

use craft\records\Entry;
use function selvinortiz\hangouts\hangouts;

class HangoutsTemplateHooks
{
    public static function hangout(&$context)
    {
        $hangout = $context['hangout'] ?? $context['entry'] ?? false;

        if ($hangout) {
            $context['isEntryPage'] = Craft::$app->request->getSegments() > 1;
            $context['isPastHangout'] = hangouts()->service->isPastHangout($hangout);
            $context['isOngoingHangout'] = hangouts()->service->isOngoingHangout($hangout);
            $context['isUpcomingHangout'] = hangouts()->service->isUpcomingHangout($hangout);
            $context['hasMeetingNotes'] = mb_strlen((string) $hangout->hangoutNotes);
        }
    }

    public static function hangouts(&$context)
    {
        $start = new \DateTime('now', new \DateTimeZone(Craft::$app->timeZone));
        $ending = (clone $start)->modify('+1 hour');
        $format = 'Y-m-d H:i:s';

        $context['upcomingHangouts'] = (new EntryQuery(\craft\elements\Entry::class))
            ->section('hangouts')
            ->orderBy('hangoutDateTime asc')
            ->hangoutDateTime('> '.$ending->format($format))
            ->limit(null)
            ->all();

        $context['previousHangouts'] = (new EntryQuery(\craft\elements\Entry::class))
            ->section('hangouts')
            ->orderBy('hangoutDateTime desc')
            ->hangoutDateTime('< '.$ending->format($format))
            ->limit(null)
            ->all();

        $context['ongoingHangout'] = (new EntryQuery(\craft\elements\Entry::class))
            ->section('hangouts')
            ->hangoutDateTime([
                'and',
                '> '.$start->format($format),
                '< '.$ending->format($format)
            ])
            ->limit(1)
            ->one();
    }

    public static function profile(&$context)
    {
        $username = $context['username'] ?? null;
        $loggedInUser = $context['user'] ?? null;
        $requestedUser = null;

        if (!$loggedInUser) {
            if ($username) {
                $requestedUser = Craft::$app->users->getUserByUsernameOrEmail($username);
            }
        }

        $context['isSessionOwner'] = $loggedInUser && $requestedUser && $loggedInUser->username === $requestedUser->username;
    }
}
