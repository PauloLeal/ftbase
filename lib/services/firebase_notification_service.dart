import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ftbase/utils/log.dart';

bool _initialized = false;

Future<void> _foregroundMessageReceived(RemoteMessage message) async {
  if (FirebaseNotificationService.instance.onForegroundMessageReceived != null) {
    return FirebaseNotificationService.instance.onForegroundMessageReceived!(message);
  }
  return Future.value();
}

Future<void> _backgroundMessageReceived(RemoteMessage message) async {
  if (FirebaseNotificationService.instance.onBackgroundMessageReceived != null) {
    return FirebaseNotificationService.instance.onBackgroundMessageReceived!(message);
  }
  return Future.value();
}

Future<void> _messageOpened(RemoteMessage message) async {
  if (FirebaseNotificationService.instance.onMessageOpened != null) {
    return FirebaseNotificationService.instance.onMessageOpened!(message);
  }
  return Future.value();
}

class FirebaseNotificationService {
  Future<void> Function(RemoteMessage message)? onForegroundMessageReceived;
  Future<void> Function(RemoteMessage message)? onBackgroundMessageReceived;
  Future<void> Function(RemoteMessage message)? onMessageOpened;

  final MethodChannel _channel = const MethodChannel("ftbase");
  bool _isAuthorized = false;

  FirebaseNotificationService._privateConstructor();
  static final FirebaseNotificationService instance = FirebaseNotificationService._privateConstructor();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> _configure({bool isRetry = false}) async {
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );
    }

    if (Platform.isAndroid) {
      InitializationSettings initializationSettings =
          const InitializationSettings(android: AndroidInitializationSettings("@mipmap/launcher_icon"));

      try {
        await _flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (value) async {
          if (value == null || value.isEmpty) {
            return Future.value();
          }

          final Map<String, dynamic> data = json.decode(value);
          if (onMessageOpened != null) {
            onMessageOpened!(RemoteMessage(data: data));
          }
          return Future.value();
        });
      } on Exception catch (e) {
        Log.error(e.toString());
        return Future.value();
      }
    }

    var ns = await FirebaseMessaging.instance.getNotificationSettings();
    if ([AuthorizationStatus.authorized, AuthorizationStatus.provisional].contains(ns.authorizationStatus)) {
      _isAuthorized = true;
      FirebaseMessaging.onBackgroundMessage(_backgroundMessageReceived);
      FirebaseMessaging.onMessageOpenedApp.listen(_messageOpened);
      FirebaseMessaging.onMessage.listen(_foregroundMessageReceived);
      _initialized = true;
    } else {
      if (!isRetry) {
        FirebaseMessaging.instance.requestPermission();
        await _configure(isRetry: isRetry);
      }
    }
  }

  Future<void> createChannel(String id, String name, String description) async {
    await _channel.invokeMethod("Notification.createChannel", {
      "id": id,
      "name": name,
      "description": description,
    });
  }

  Future<void> deleteChannel(String id) async {
    await _channel.invokeMethod("Notification.deleteChannel", {
      "id": id,
    });
  }

  Future<List<Map<String, String>>> listChannels() async {
    List<Map<String, String>> res = List.empty(growable: true);

    dynamic list = await _channel.invokeMethod("Notification.listChannels", {});

    for (var l in list) {
      res.add(Map.from(l));
    }
    return res;
  }

  void subscribe(String topicName) async {
    if (!_initialized || _isAuthorized) {
      return;
    }

    Log.info("Subscribing to $topicName");
    await FirebaseMessaging.instance.subscribeToTopic(topicName);
  }

  void unsubscribe(String topicName) async {
    if (!_initialized || !_isAuthorized) {
      return;
    }

    Log.info("Unsubscribing to $topicName");
    await FirebaseMessaging.instance.unsubscribeFromTopic(topicName);
  }

  Future<RemoteMessage?> getInitialMessage() async {
    return FirebaseMessaging.instance.getInitialMessage();
  }

  Future<void> initialize() async => _configure(isRetry: false);

  Future<void> showLocalNotification(String channelId, String channelName, RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (Platform.isAndroid && notification != null && android != null) {
      _flutterLocalNotificationsPlugin.show(
        Random(DateTime.now().microsecondsSinceEpoch).nextInt(pow(2, 31).toInt() - 1),
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            icon: "@mipmap/launcher_icon",
            // other properties...
          ),
        ),
        payload: json.encode(message.data),
      );
    }
  }
}
