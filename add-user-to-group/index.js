const AWS = require("aws-sdk");
const cognitoIdp = new AWS.CognitoIdentityServiceProvider();

exports.handler = async (event, context) => {
  try {
    console.log("Event:", JSON.stringify(event, null, 2));

    if (!event.userPoolId || !event.userName) {
      throw new Error("Missing userPoolId or userName in event");
    }

    const groupParams = {
      GroupName: "absoluteUser",
      UserPoolId: event.userPoolId,
      Username: event.userName,
    };

    await cognitoIdp.adminAddUserToGroup(groupParams).promise();
    console.log(`✅ Successfully added ${event.userName} to absoluteUser group`);

    return event;
  } catch (error) {
    console.error("❌ Error adding user to group:", error);
    return event;
  }
};
