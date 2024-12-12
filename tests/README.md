# Tests

```bash
# Install Newman
npm install newman

# Run tests (default base URL)
node ./node_modules/newman/bin/newman.js run dynlink.postman_collection.json -e dynlink.postman_environment.json

# Run tests (custom base URL -- Make sure to omit the final "/")
node ./node_modules/newman/bin/newman.js run dynlink.postman_collection.json --env-var "baseurl=https://dyn.link"
```
