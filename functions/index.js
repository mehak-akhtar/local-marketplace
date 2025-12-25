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

// ✅ Watch fcm_queue collection and send FCM
exports.sendFCMNotification = functions.firestore
  .document('fcm_queue/{queueId}')
  .onCreate(async (snap, context) => {
    const data = snap.data();
    
    if (data.status !== 'pending') return;

    const message = {
      token: data.token,
      notification: {
        title: data.notification.title,
        body: data.notification.body,
      },
      data: data.data,
      android: {
        priority: 'high',
        notification: {
          sound: 'default',
          channelId: 'getcars_channel',
        },
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
            badge: 1,
          },
        },
      },
    };

    try {
      await admin.messaging().send(message);
      console.log('✅ FCM sent successfully');
      
      // Mark as sent
      await snap.ref.update({ 
        status: 'sent', 
        sentAt: admin.firestore.FieldValue.serverTimestamp() 
      });
    } catch (error) {
      console.error('❌ Error sending FCM:', error);
      await snap.ref.update({ 
        status: 'failed', 
        error: error.message 
      });
    }
  });