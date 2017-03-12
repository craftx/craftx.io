'use strict';

import Vue from 'vue';
import {postToController, displaySuccessMessage, displayErrorMessage} from './Utils';

export default new Vue({
    el: '#newsletter',
    data: {
        busy: false,
        email: ''
    },
    methods: {
        subscribeToNewsletter() {
            this.busy = true;

            if (!this.email) {
                displayErrorMessage('Hey!', 'You should add your email address, please.');

                this.busy = false;

                return;
            }

            let params = {
                email: this.email
            };

            let vm = this;

            postToController(
                'swipe/newsletter/subscribe',
                params,
                // OK
                (response) => {
                    if (response.data.success) {
                        displaySuccessMessage(response.data.title, response.data.message.replace('{email}', response.data.params.email));
                        vm.email = '';
                    } else {
                        displayErrorMessage(response.data.title, response.data.message);
                    }

                    vm.busy = false;
                },
                // Error
                (response) => {
                    displayErrorMessage('I\'m sorry!', 'Looks like I could not get you subscribed;(');
                    console.log(response);

                    vm.busy = false;
                }
            );
        }
    }
});
