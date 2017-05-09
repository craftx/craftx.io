<?php
namespace selvinortiz\hangouts\twig;

use Craft;

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
            $context['host'] = $hangout->hangoutHost->one();
            $context['guests'] = $hangout->hangoutGuests->all() ?? [];
            $context['presenters'] = $hangout->hangoutPresenters->all() ?? [];
        }
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
