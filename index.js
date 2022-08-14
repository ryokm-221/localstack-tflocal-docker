const aws = require('aws-sdk')
const DynamoDB = new aws.DynamoDB({
  region: 'ap-northeast-1',
  endpoint: process.env.DynamoDBEndpoint
})

// Payload example: { Id: "1234-5678", Item: "banana" }
exports.handler = async (event) => {
  console.log(event)
  const res = await DynamoDB.putItem({
    Item: {
      Id: { S: event.Id },
      Item: { S: event.Item }
    },
    TableName: process.env.DynamoDBTableName
  }).promise()
  return res
}
