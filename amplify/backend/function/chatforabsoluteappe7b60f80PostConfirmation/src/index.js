const AWS = require('aws-sdk');
const cognito = new AWS.CognitoIdentityServiceProvider();

exports.handler = async (event, context, callback) => {
  const groupParams = {
    GroupName: 'absoluteUser', // Must match the group you created
    UserPoolId: event.userPoolId,
    Username: event.userName,
  };

  try {
    await cognito.adminAddUserToGroup(groupParams).promise();
    console.log(`✅ Added user ${event.userName} to group absoluteUser`);
  } catch (err) {
    console.error(`❌ Failed to add user to group: ${err.message}`);
  }

  // Always return the event back
  callback(null, event);
};
