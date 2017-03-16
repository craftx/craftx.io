'use strict';

import Stripe from 'stripe';
import Vue from 'vue';

import {postToController, debounce} from './Utils';

import CXEmailInput from './components/CXEmailInput.vue';
import CXUsernameInput from './components/CXUsernameInput.vue';

export default new Vue({
    el: '#join',
    delimiters: ['@{', '}'],
    components: {
        cxEmail: CXEmailInput,
        cxUsername: CXUsernameInput,
    },
    data: {
        email: '',
        username: '',
        password: '',
        firstName: '',
        lastName: '',
        busy: false,
    },
    methods: {
        join(event) {

            if (this.busy) {
                return;
            }

            this.busy = true;

            return event.target.submit();
        }
    }
});
