<template>
    <div class="is-control-container">
        <p class="control">
            <label class="label">Username</label>
            <input
                type="text"
                name="username"
                class="input is-medium"
                autocomplete="off"
                required
                :placeholder="placeholder"
                v-model="username"
                @keyup="validate"
            >
            <span class="help" v-if="hint">{{ hint }}</span>
        </p>
    </div>
</template>

<script>
    import {postToController, debounce} from '../Utils';

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

                debounce(() => {
                    if (!!vm.username && vm.username.length < 5) {
                        vm.hint = 'Must be at least 5 characters long';
                        return;
                    }
                    if (!vm.busy) {
                        vm.busy = true;
                        postToController(
                            'swipe/users/validate-username',
                            {
                                username: vm.username
                            },
                            (response) => {
                                vm.hint = response.data.message;
                                vm.busy = false;
                            },
                            (response) => {
                                vm.hint = 'Unable to validate username';
                                vm.busy = false;
                            }
                        );
                    }
                }, 500)();
            }
        }
    }
</script>
