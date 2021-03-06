'use strict';

import Vue from 'vue';
import timezone from 'jstz';
import {postToController} from './Utils';

new Vue({
    el: '#dateTimeTable',
    delimiters: ['${', '}'],
    data: {
        day: null,
        date: null,
        time: null,
        timezone: null,
        zoneIdentifier: null,
        zoneAbbreviation: null,
    },
    mounted() {
        this.$nextTick(() => {
            this.timezone = timezone.determine().name();

            if (this.timezone) {
                postToController(
                    'hangouts/default/get-date-time-data',
                    {
                        sourceDateTime: window.hangoutSourceDateTime,
                        destinationTimeZone: this.timezone
                    },
                    (response) => {
                        if (response.data.success) {
                            this.day = response.data.day;
                            this.date = response.data.date;
                            this.time = response.data.time;
                            this.zoneIdentifier = response.data.zoneIdentifier;
                            this.zoneAbbreviation = response.data.zoneAbbreviation;
                        } else {
                            this.timezone = null;
                        }
                    },
                    () => {
                        this.timezone = null;
                    }
                );
            }
        }, this);
    }
});
