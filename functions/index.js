const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Listen for new notifications in Firestore
exports.sendNotification = functions.firestore
  .document('notifications/{notificationId}')
  .onCreate(async (snap, context) => {
    const notification = snap.data();
    
    // Get user's FCM token
    const userDoc = await admin.firestore()
      .collection('users')
      .doc(notification.userId)
      .get();
    
    const fcmToken = userDoc. data()?.fcmToken;
    
    if (! fcmToken) {
      console.log('No FCM token for user:', notification.userId);
      return;
    }
    
    // Send FCM message
    const message = {
      notification:  {
        title: notification.title,
        body: notification.message,
      },
      data:  {
        type: notification.type,
        ... notification.data,
      },
      token: fcmToken,
    };
    
    try {
      await admin.messaging().send(message);
      console.log('✅ FCM sent:', notification.title);
    } catch (error) {
      console.error('❌ Error sending FCM:', error);
    }
  });