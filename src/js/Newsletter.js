'use strict';

import Vue from 'vue';
import Helper from './Helper';

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
                Helpers.__nay('Hey!', 'You should add your email address.');

                this.busy = false;

                return;
            }

            let params = {
                email: this.email
            };

            let vm = this;

            Helper.post(
                '/actions/swipe/newsletter/subscribe',
                params,
                // OK
                (response) => {
                    if (response.data.success) {
                        Helpers.__yay(response.data.title, response.data.message.replace('{email}', response.data.params.email));
                        vm.email = '';
                    } else {
                        Helpers.__nay(response.data.title, response.data.message);
                    }

                    vm.busy = false;
                },
                // Error
                (response) => {
                    Helpers.__nay('I\'m sorry!', 'Looks like I could not get you subscribed;(');
                    console.log(response);

                    vm.busy = false;
                }
            );
        }
    }
});
