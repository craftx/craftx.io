'use strict';

Vue.config.delimiters = ['${', '}'];
Vue.prototype.$http   = axios;

// Emulate JSON

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
        subscribe: function(e) {
            var app = this;

            this.subscribing = true;
            
            if (!this.email)
            {
                this.__nay('Wait...', 'Email is required.');

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
                        app.__yay('Fantastic!', response.data.message);
                        app.name = '';
                        app.email = '';
                    } else {
                        app.__nay('Wait...', response.data.message);
                    }

                    app.subscribing = false;
                },
                // Error
                function(response) {
                    app.__nay('Shoot...', 'I could not get you subscribed.');

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
