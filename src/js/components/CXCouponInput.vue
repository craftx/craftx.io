<template>
    <div class="is-control-container">
        <p class="control">
            <label class="label">Username</label>
            <input
                type="text"
                name="username"
                class="input is-large"
                autocomplete="off"
                :placeholder="placeholder"
                v-model="username"
                @keyup="validate"
            >
            <span class="help" v-if="hint">{{ hint }}</span>
        </p>
    </div>
</template>

<script>
    let __ = require('lodash');
    let Helpers = require('../helpers');

    export default {
        props: ['value', 'placeholder'],
        data() {
            return {
                busy: false,
                hint: '',
                label: '',
                username: this.value
            }
        },
        methods: {
            validate() {
                let vm = this;

                __.debounce(() => {
                    if (vm.username.length < 5) { return; }
                    if (!vm.busy) {
                        vm.busy = true;
                        Helpers.__post(
                            '/actions/swipe/users/validate-username',
                            {
                                username: vm.username
                            },
                            (response) => {
                                console.log(response.data.success ? 'Success' : 'Error');
                                vm.hint = response.data.message;
                                vm.busy = false;
                            },
                            (response) => {
                                console.log('Error');
                                vm.hint = response.data.message;
                                vm.busy = false;
                            }
                        );
                    }
                }, 500)();
            }
        }
    }
</script>
