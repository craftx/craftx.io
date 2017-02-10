'use strict';

Vue.prototype.$http = axios;
Vue.config.delimiters = ['${', '}'];

var app = new Vue({
    el: '#app',
    data: {
        email: '',
        subscribing: false,
        mobileNavIsActive: false
    },
    methods: {
        toggleMobileNav: function() {
            this.mobileNavIsActive = !this.mobileNavIsActive;
        },
        subscribe: function() {
            var app = this;

            this.subscribing = true;
            
            if (!this.email)
            {
                this.__nay('Hey!', 'You should add your email address.');

                this.subscribing = false;

                return;
            }

            var body = {
                email: this.email
            };

            body[csrfTokenName] = csrfTokenValue;

            this.$http.post('/actions/swipe/newsletter/subscribe', body)
            .then(
                // OK
                function(response) {
                    if (response.data.success) {
                        app.__yay('Doing Great!', response.data.message);
                        app.name = '';
                        app.email = '';
                    } else {
                        app.__nay('Wait!', response.data.message);
                    }

                    app.subscribing = false;
                },
                // Error
                function(response) {
                    console.log(response);
                    app.__nay('Oh No!', 'Looks like I could not get you subscribed:(');

                    app.subscribing = false;
                }
            );
        },
        __yay: function(title, message) {
            swal({
                title: title,
                text: message,
                type: "success",
                confirmButtonColor: '#00966c'
            });
        },
        __nay: function(title, message) {
            swal({
                title: title,
                text: message,
                type: "error",
                confirmButtonColor: '#00966c'
            });
        }
    }
});
