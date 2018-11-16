const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.helloWorld = functions.https.onRequest((request, response) => {
    response.send("Hello from Firebase! Hsin!");
});

exports.testFunction = functions.https.onRequest((request, response) => {
    response.send('GG');
});

exports.sendPushNotificationGG = functions.https.onRequest((req, res) => {
    res.send('Attemp to push notification...GG');
    var uid = 'eFRkzhk6SsSuYSuqyJKNj0z35EV2';
    var dbRef = admin.database().ref('/users/' + uid);
    return dbRef.once('value', function (snapshot) {
        var user = snapshot.val();
        console.log("user: " + user);
        console.log("User name: " + user.userName + ", fcmTocken: " + user.fcmTocken);
        // This registration token comes from the client FCM SDKs.
        var fcmTocken = user.fcmTocken;

        // See the "Defining the message payload" section below for details
        // on how to define a message payload.
        var payload = {
            notification: {
                title: 'put title here...',
                body: 'put body here...',
                sound: 'default',
            },
        };

        // Send a message to the device corresponding to the provided
        // registration token.
        admin.messaging().sendToDevice(fcmTocken, payload)
            .then(function (response) {
                // See the MessagingDevicesResponse reference documentation for
                // the contents of response.
                console.log("Successfully sent message:", response);
            })
            .catch(function (error) {
                console.log("Error sending message:", error);
            });
    });

});


exports.observeFollowings = functions.database.ref('/followings/:uid/:followingId')
    .onCreate(function (event) {
        var uid = event.paramas.uid;
        var followingId = event.paramas.followingId;
        console.log('uid: ' + uid + ', followingId: ' + followingId);
        return true
    })