'use strict';

import timezone from 'jstz';

new Vue({
    el: '#root',
    delimiters: ['${', '}'],
    data: {
        timezone: timezone.determine().name()
    }
});
