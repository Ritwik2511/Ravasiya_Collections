import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_init.dart';





Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // await setupFlutterNotifications();

  Future.delayed(Duration.zero, () {
    flutterLocalNotificationsPlugin.cancelAll();
    _showNotification(message);
  });

}

Future<void> _showNotification(RemoteMessage message) async {
  Map mapData = {"link": message.notification!.android!.link, "action": message.notification!.android!.clickAction, "storyId": message.data["story_id"]};

  String payload = json.encode(mapData);
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    'be.fit.workout.fitness',
    'big text channel name',
    channelDescription: 'big text channel description',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(1, message.notification!.title, message.notification!.body!, notificationDetails, payload: payload);

  _configureSelectNotificationSubject();
  _configureDidReceiveLocalNotificationSubject();
}
void _configureDidReceiveLocalNotificationSubject() {

  didReceiveLocalNotificationStream.stream.listen((ReceivedNotification receivedNotification) async {

    Map payload = json.decode(receivedNotification.payload!);

    String action = payload["action"];

    if (action == "FLUTTER_NOTIFICATION_CLICK") {
    } else if (action == "FLUTTER_NOTIFICATION_CLICK_STORY") {
    }
  });
}
Future<void> _configureSelectNotificationSubject() async {



  selectNotificationStream.stream.listen((receive) async {

    Map payload = json.decode(receive!);



    String action = payload["action"];

    if (action == "FLUTTER_NOTIFICATION_CLICK") {
    } else if (action == "FLUTTER_NOTIFICATION_CLICK_STORY") {}
  });
  // }
}




class FirebaseInit{

  static init()async{


    await Firebase.initializeApp(


    );



    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );



    FirebaseMessaging.onBackgroundMessage(backgroundHandler);


    FirebaseMessaging.instance.getToken().then((value){
    });






    FirebaseMessaging.onMessage.listen((event) {

      Future.delayed(Duration.zero, () {
        flutterLocalNotificationsPlugin.cancelAll();
        _showNotification(event);
      });

    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {


    });

    FirebaseMessaging.instance.getInitialMessage().then((value) {



    });



  }



}