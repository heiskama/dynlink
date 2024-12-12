import * as crypto from 'crypto';
import * as logger from './logger.cjs';

const buildResponseJSON = (statusCode, body = {}) => {
  const response = {
    "statusCode": statusCode,
     "headers": {
      "Content-Type": "application/json",
     },
     "body": JSON.stringify(body),
     "isBase64Encoded": false
  }
  return response
}

// Generate a 302 redirect response
const buildRedirect = (url) => {
  const response = {
    statusCode: 302,
    headers: {
      'Location': url,
    },
    "isBase64Encoded": false
  };
  return response
}

// Generate base64 URL safe encoded string of length 6 - 22 characters from an URL string.
const generateId = (url, length = 22) => {
  const hashobj = JSON.stringify({
    'url': url,
  })
  const md5sum = crypto.createHash('md5').update(hashobj)
  const hashLength = Math.max(6, Math.min(22, length))
  const id = md5sum.digest('base64url').substring(0, hashLength)
  logger.log('generateId:', url, id)
  return id
}

const base64decode = (text) => {
  return Buffer.from(text, 'base64').toString('utf-8')
}

export {
  buildResponseJSON,
  buildRedirect,
  generateId,
  base64decode
}
