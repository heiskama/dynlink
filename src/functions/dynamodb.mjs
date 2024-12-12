// https://docs.aws.amazon.com/sdk-for-javascript/v3/developer-guide/javascript_dynamodb_code_examples.html

import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient } from "@aws-sdk/lib-dynamodb";
import { PutCommand } from "@aws-sdk/lib-dynamodb";
import { GetCommand } from "@aws-sdk/lib-dynamodb";
import { DeleteCommand } from "@aws-sdk/lib-dynamodb";
import * as logger from './logger.cjs';

const tableName = process.env.DYNAMODB_TABLE
const defaultExpireTimeInDays = isNaN(Number(process.env.EXPIRE_LINK_IN_DAYS)) ? 30 : Number(process.env.EXPIRE_LINK_IN_DAYS)

const client = new DynamoDBClient({});
const docClient = DynamoDBDocumentClient.from(client);

const getExpireTime = (days) => {
  const currentTime = new Date().getTime();
  const epochTime = Math.floor(currentTime / 1000);
  const expireTime = (epochTime + (days * 24 * 60 * 60))
  //const expireTime = (requestContext.timeEpoch + (days * 24 * 60 * 60))
  return expireTime
}

const setData = async (id, url, ttl = defaultExpireTimeInDays) => {
  // Prepare parameters
  const params = {
    TableName: tableName,
    Item: {
      'ID': id,
      'URL': url,
      'TTL': getExpireTime(ttl),
    }
  };
  logger.debug('setData params:', params)

  // Write data
  try {
    const command = new PutCommand(params);
    const response = await docClient.send(command);
    logger.debug(response);
    logger.log('putItem was successful')
    return response;
  } catch (error) {
    const message = `Error with putItem`;
    logger.error(message);
    logger.error(error);
    throw new Error(message);
  }
}

const getData = async (id) => {
  // Prepare parameters
  const params = {
    TableName: tableName,
    Key: {
      'ID': id
    },
  };
  logger.debug('getData params:', params)

  // Read data
  try {
    const command = new GetCommand(params);
    const response = await docClient.send(command);
    /*
    Returned data when key is found:
    {
      '$metadata': {
        httpStatusCode: 200,
        requestId: 'S5GRBQK5E76MLPH3CSPBKQP8I7VV4KQNSO5AEMVJF66Q9ASUAAJG',
        extendedRequestId: undefined,
        cfId: undefined,
        attempts: 1,
        totalRetryDelay: 0
      },
      Item: {
        ID: 'YEjWstfNEcwuSkI8kO2TTg',
        TTL: 1734093627,
        URL: 'https://google.com'
      }
    }

    Returned data when key is not found:
    {
      '$metadata': {
        httpStatusCode: 200,
        requestId: '0I2629A9BGK8T123G6887OTBLVVV4KQNSO5AEMVJF66Q9ASUAAJG',
        extendedRequestId: undefined,
        cfId: undefined,
        attempts: 1,
        totalRetryDelay: 0
      }
    }
    */
    logger.log('getData response:', response)
    return response;
  } catch (error) {
    const message = `Error with getItem`;
    logger.error(message);
    logger.error(error);
    throw new Error(message);
  }
}

const deleteData = async (id) => {
  // Prepare parameters
  const params = {
    TableName: tableName,
    Key: {
      'ID': id
    }
  };
  logger.debug('deleteData params:', params)

  try {
    const command = new DeleteCommand(params);
    const response = await docClient.send(command);
    logger.debug(response);
    logger.log('Item deleted:', id)
    return true
  } catch (error) {
    const message = `Error with deleteItem`;
    logger.error(message);
    logger.error(error);
    throw new Error(message);
  }
};

export {
  setData,
  getData,
  deleteData
}
