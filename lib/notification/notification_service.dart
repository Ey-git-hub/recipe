import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService instance = NotificationService._init();
  NotificationService._init();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    tz.initializeTimeZones();
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(settings: settings);
  }

  Future<void> requestPermission() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required int secondsLater,
  }) async {
    const AndroidNotificationDetails androidDtails = AndroidNotificationDetails(
      'recipe_reminder_channel_id',
      "Recipe Reminders",
      channelDescription: 'Channel for recipe cooking reminders',
      importance: Importance.max,
      priority: Priority.max,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDtails,
    );
    final scheduledTime = tz.TZDateTime.now(tz.local)
        .add(Duration(seconds: secondsLater));
    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledTime, // እዚህ ጋ ያሰላኸውን የወደፊት ሰዓት ትሰጠዋለህ
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
