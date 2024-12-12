import * as helpers from './helpers.mjs';
import * as db from './dynamodb.mjs';
import * as logger from './logger.cjs';

const shortUrlBase = process.env.BASE_URL

export const handler = async (event, context) => {
  // Log some info for debugging purposes
  logger.debug('event:', event)
  logger.debug('context:', context)
  logger.log(`Call to ${event.rawPath}`)

  // Parse request and build a response
  // Accept POST requests with 'url' field defined
  let response
  if (event.requestContext.http.method === "POST" && typeof event.body === 'string' &&
  helpers.base64decode(event.body).trim().startsWith("url=")) {
    const url = helpers.base64decode(event.body).trim().replace("url=", "")
    const id = helpers.generateId(url)
    try {
      await db.setData(id, url)
      response = helpers.buildResponseJSON(200, {
        "long_url": url,
        "short_url": shortUrlBase + id,
        "status": "OK",
      })
    } catch(error) {
      response = helpers.buildResponseJSON(500, { message: 'Internal Server Error', status: 'ERROR' })
      logger.error(error, response)
    }
  }
  // Invalid request
  else {
    response = helpers.buildResponseJSON(400, { message: 'Bad Request', status: 'ERROR' })
    logger.warn(event, context, response)
  }

  // Send a response
  logger.debug('response:', response)
  return response
};

export default handler;
