import Alert from 'sweetalert';
import Axios from 'axios';
import {
    debounce
} from 'lodash';

const axiosConfig = {
    headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': csrfTokenValue,
        'ACCEPTS': 'application/json'
    }
};

export {postToController, displayErrorMessage, displaySuccessMessage, debounce};

/**
 * Post to a controller action via Ajax
 *
 * @param {String} url
 * @param {Object} data 
 * @param {Function} success 
 * @param {Function} failure 
 */
function postToController(url, data = {}, success = function () {}, failure = function () {}) {
    Axios.post('/actions/' + url, data, axiosConfig)
        .then(success, failure);
}

/**
 * Display a custom success alert
 *
 * @param {String} title 
 * @param {String} message 
 */
function displaySuccessMessage(title, message) {
    Alert({
        title: title,
        text: message,
        type: "success",
        confirmButtonColor: '#00966c'
    });
}

/**
 * Display a error alert
 *
 * @param {String} title 
 * @param {String} message 
 */
function displayErrorMessage(title, message) {
    Alert({
        title: title,
        text: message,
        type: 'error',
        confirmButtonColor: '#00966c'
    });
}

