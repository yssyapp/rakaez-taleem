// نسخة نموذجية بقيم وهمية — تُستخدم فقط لفحص الكود (CI) بدون كشف المفاتيح الحقيقية.
// النسخة الفعلية (firebase_options.dart) موجودة على جهازك فقط ومستثناة من المستودع.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'dummy-api-key',
    appId: 'dummy-app-id',
    messagingSenderId: 'dummy-sender-id',
    projectId: 'dummy-project-id',
    storageBucket: 'dummy-project-id.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'dummy-api-key',
    appId: 'dummy-app-id',
    messagingSenderId: 'dummy-sender-id',
    projectId: 'dummy-project-id',
    storageBucket: 'dummy-project-id.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'dummy-api-key',
    appId: 'dummy-app-id',
    messagingSenderId: 'dummy-sender-id',
    projectId: 'dummy-project-id',
    storageBucket: 'dummy-project-id.appspot.com',
    iosBundleId: 'com.example.rakaezAlMaarifa',
  );
}
