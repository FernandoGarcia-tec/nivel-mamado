
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final timerServiceProvider = Provider((ref) => TimerService());

class TimerService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  Timer? _timer;
  final ValueNotifier<int> remainingSeconds = ValueNotifier(0);

  TimerService() {
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon'); // Ensure you have 'app_icon.png' in android/app/src/main/res/drawable
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await _notificationsPlugin.initialize(initializationSettings);
  }

  void startTimer(int seconds) {
    stopTimer(); // Ensure any existing timer is stopped
    remainingSeconds.value = seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        stopTimer();
        _showRestFinishedNotification();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  Future<void> _showRestFinishedNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'rest_timer_channel', 
      'Rest Timer',
      channelDescription: 'Notifications for when your rest timer is up',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      sound: RawResourceAndroidNotificationSound('notification_sound'), // Add a sound file to android/app/src/main/res/raw
      icon: 'app_icon',
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      0,
      '¡Tiempo Cumplido!',
      'El descanso ha terminado. ¡A darle al siguiente set!',
      platformChannelSpecifics,
    );
  }
}
