import * as helpers from './helpers.mjs';
import * as db from './dynamodb.mjs';
import * as logger from './logger.cjs';

export const handler = async (event, context) => {
  // Log some info for debugging purposes
  logger.debug('event:', event)
  logger.debug('context:', context)
  logger.log(`Call to ${event.rawPath}`)

  // Parse request and build a response
  // Accept GET requests and assume the last part of request path is the 'id'
  let response
  if (event.requestContext.http.method === "GET" && event.requestContext.http.path === "/favicon.ico") {
    response = helpers.buildResponseJSON(404, { message: 'Not Found', status: 'ERROR' })
  }
  else if (event.requestContext.http.method === "GET") {
    try {
      const id = event.rawPath.split("/").pop()
      const data = await db.getData(id)
      // ID not found in DB
      if (typeof data === 'undefined' || typeof data.Item === 'undefined' || typeof data.Item.URL === 'undefined') {
        response = helpers.buildResponseJSON(404, { message: 'Not Found', status: 'ERROR' })
        logger.info(event, context, response)
      }
      // ID found
      else {
        response = helpers.buildRedirect(data.Item.URL)
        logger.log('Redirect to', data.Item.URL)
      }
    } catch(error) {
      response = helpers.buildResponseJSON(500, { message: 'Internal Server Error', status: 'ERROR' })
      logger.error(error, event, context, response)
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
