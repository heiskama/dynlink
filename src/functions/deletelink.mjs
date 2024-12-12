import * as helpers from './helpers.mjs';
import * as db from './dynamodb.mjs';
import * as logger from './logger.cjs';

export const handler = async (event, context) => {
  // Log some info for debugging purposes
  logger.debug('event:', event)
  logger.debug('context:', context)
  logger.log(`Call to ${event.rawPath}`)

  // Parse request and build a response
  // Accept POST requests with 'id' field defined and correct api key in headers
  let response
  if (event.headers["private-api-key"] === process.env["PRIVATE_API_KEY"] &&
  event.requestContext.http.method === "POST" && typeof event.body === 'string' &&
  helpers.base64decode(event.body).trim().startsWith("id=")) {
    const id = helpers.base64decode(event.body).trim().replace("id=", "")
    try {
      await db.deleteData(id)
      response = helpers.buildResponseJSON(200, {
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
