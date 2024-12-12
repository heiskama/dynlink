const crypto = require('crypto');

// Get the request body
const requestBody = pm.request.body.formdata;

// Serialize the request body
let bodyString = '';
requestBody.each((param) => {
  bodyString += `${param.key}=${param.value}&`;
});
bodyString = bodyString.slice(0, -1); // Remove the trailing '&'

// Hash the body string with SHA256
const hash = crypto.createHash('sha256').update(bodyString).digest('hex');

// Set the hash in the headers
pm.request.headers.add({
  key: 'x-amz-content-sha256',
  value: hash
});
