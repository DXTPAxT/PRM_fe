import 'package:flutter/foundation.dart';

class Env {
  Env._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: kIsWeb ? 'http://localhost:3000/api' : 'http://10.0.2.2:3000/api',
  );
}

