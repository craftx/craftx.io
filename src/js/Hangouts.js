'use strict';

import Vue from 'vue';
import timezone from 'jstz';
import {postToController} from './Utils';

new Vue({
    el: '#root',
    delimiters: ['${', '}'],
    data: {
        date: null,
        time: null,
        zone: null,
        timezone: timezone.determine().name()
    },
    mounted() {
        this.$nextTick(() => {
            console.log(window);
            if (this.timezone) {
                postToController(
                    'hangouts/default/get-date-time-data',
                    {
                        sourceDateTime: window.hangoutSourceDateTime,
                        destinationTimeZone: this.timezone
                    },
                    (response) => {
                        if (response.data.success) {
                            this.date = response.data.date;
                            this.time = response.data.time;
                            this.zone = response.data.zone;
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
