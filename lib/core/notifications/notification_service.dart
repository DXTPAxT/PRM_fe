import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _fcm;

  NotificationService({FirebaseMessaging? fcm}) : _fcm = fcm ?? FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permissions
    await requestPermission();

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Listen to background message click events (when app is opened from background)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationClick);

    // Check if app was opened from a terminated state via push notification
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationClick(initialMessage);
    }
  }

  Future<void> requestPermission() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    print('Quyền thông báo: ${settings.authorizationStatus}');
  }

  Future<String?> getFCMToken() async {
    try {
      return await _fcm.getToken();
    } catch (e) {
      print('Không thể lấy FCM token: $e');
      return null;
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print('Nhận được thông báo trong foreground:');
    print('Tiêu đề: ${message.notification?.title}');
    print('Nội dung: ${message.notification?.body}');
    print('Dữ liệu kèm theo: ${message.data}');
  }

  void _handleNotificationClick(RemoteMessage message) {
    print('Người dùng nhấp vào thông báo: ${message.data}');
  }
}
