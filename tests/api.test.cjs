"use strict";

// https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API/Using_Fetch
// Run with: `node --test`
// This will run `**/*.test.js` files with the built in test runner. This will make a few simple API calls to check that services are working and print a report.

const test = require('node:test');  // https://nodejs.org/api/test.html
const assert = require('assert');  // https://nodejs.org/api/assert.html

const baseURL = "https://dyn.link/"

// Q: https://repost.aws/questions/QUbHCI9AfyRdaUPCCo_3XKMQ/lambda-function-url-behind-cloudfront-invalidsignatureexception-only-on-post
// A: https://devdoc.net/web/developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/digest.html#:~:text=Syntax%20var%20hash%20%3D%20crypto.subtle.digest%28algo%2C%20buffer%29%3B%20Parameters%20algo,be%20hashed%20using%20the%20hashing%20algorithm.%20Return%20value
async function sha256(message) {
  var msgBuffer = new TextEncoder('utf-8').encode(message);                      // encode as UTF-8
  var hashBuffer = await crypto.subtle.digest('SHA-256', msgBuffer);             // hash the message
  var hashArray = Array.from(new Uint8Array(hashBuffer));                        // convert ArrayBuffer to Array
  var hashHex = hashArray.map(b => ('00' + b.toString(16)).slice(-2)).join('');  // convert bytes to hex string
  return hashHex;
}

async function get(url) {
  const result = await fetch(url)
  return result
}

// Lambda URLs require SHA256 hash of the body in header for POST and PUT requests
// TODO: Fix. This doesn't work yet.
async function post(url, data) {
  const body = "url=" + data.url.trim();
  const bodyHash = await sha256(body);
  const result = await fetch(url, {
    method: "POST",
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'x-amz-content-sha256': bodyHash
    },
    body: body
  })
  return result
}

async function main() {
  let state = {}

  state.testURL = baseURL
  await test(`Get ${state.testURL}`, async (t) => {
    const response = await get(state.testURL);
    assert.strictEqual(response.status, 200);
    assert.strictEqual(response.headers.get("Content-Type").startsWith("text/html"), true)
  });

  state.testURL = baseURL + "index.html"
  await test(`Get ${state.testURL}`, async (t) => {
    const response = await get(state.testURL);
    assert.strictEqual(response.status, 200);
    assert.strictEqual(response.headers.get("Content-Type").startsWith("text/html"), true)
  });

  state.testURL = baseURL + "/api/setlink"
  await test('Set link test 1', async (t) => {
    const response = await post(state.testURL, { url: "https://google.com" });
    assert.strictEqual(response.status, 200);
    assert.strictEqual(response.headers.get("Content-Type").startsWith("application/json"), true)
    const body = await res.json()
    assert.strictEqual(body.long_url, "https://google.com");
    assert.strictEqual(body.short_url, "https://google.com");
    state.longURL = body.long_url
    state.shortURL = body.short_url
  });

  state.testURL = state.shortURL
  await test('Get link test 1', async (t) => {
    const response = await get(state.testURL);
    assert.strictEqual(response.status, 302);
    assert.strictEqual(response.headers.get("Location"), state.longURL)
  });
}

main()
