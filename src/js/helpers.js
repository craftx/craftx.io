let Alert = require('sweetalert');
let Axios = require('axios');

let axiosConfig = {
    headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': csrfTokenValue,
        'ACCEPTS': 'application/json'
    }
};

module.exports = {
    __yay(title, message) {
        Alert({
            title: title,
            text: message,
            type: "success",
            confirmButtonColor: '#00966c'
        });
    },
    __nay(title, message) {
        Alert({
            title: title,
            text: message,
            type: "error",
            confirmButtonColor: '#00966c'
        });
    },
    __post(url, data = {}, success = function() {}, failure = function() {}) {
        Axios.post(url, data, axiosConfig)
            .then(success, failure);
    }
};
