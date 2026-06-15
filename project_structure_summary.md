# وثائق بنية مشروع usmart

## نظرة عامة عامة

هذا المشروع هو تطبيق Flutter باسم `usmart` مصمم للتحكم في مظلة ذكية (Smart Umbrella). يعتمد التطبيق على Flutter وRiverpod لتطبيق واجهة مستخدم مميزة مع دعم شاشة العرض الرئيسية، والتحكم في الإضاءة، والصوت، والبطارية.

---

## الملفات الأساسية في جذر المشروع

- `pubspec.yaml`
  - يحتوي على إعدادات المشروع ونسخة التطبيق والاعتمادات.
  - يستخدم Flutter مع Riverpod وGoRouter وSharedPreferences وGoogle Fonts.

- `README.md`
  - ملف الوثائق الرئيسي للمشروع، لكنه حاليًا نص تمهيدي وليس وثيقة تقنية كاملة.

- `analysis_options.yaml`, `devtools_options.yaml`
  - إعدادات تحليل الكود ومطابقة قواعد الجودة.

- `android/`, `ios/`, `linux/`, `macos/`, `windows/`, `web/`
  - مجلدات المنصات الخاصة بالتطبيق.
  - تحتوي على ملفات البناء الأصلية لكل منصة مثل Gradle وXcode وCMake.

- `assets/`
  - الصور، الأيقونات، الشعار، الخطوط.
  - يستخدم التطبيق هذا المجلد لعرض الواجهة الرسومية.

- `lib/`
  - يحتوي كود التطبيق الرئيسي.
  - أهم مجلد في المشروع.

- `build/`
  - مجلد النتائج الناتجة عن بناء التطبيق.
  - لا تحتاج عادةً لتعديله يدويًا.

- `test/`
  - مجلد اختبارات Flutter.
  - يحتوي حاليًا على ملف واحد للاختبارات.

---

## مجلد `lib/` ووظيفته

### `lib/main.dart`

- نقطة الدخول للتطبيق.
- يضبط اتجاه الشاشة (Portrait فقط).
- يعيّن سمات الضوء والظلام (`AppTheme.lightTheme` و`AppTheme.darkTheme`).
- يستخدم `ProviderScope` من Riverpod لتفعيل إدارة الحالة.
- يوجّه `MaterialApp.router` إلى `routerProvider` لبناء التنقل.

### `lib/core/`

هذا المجلد هو قلب البنية العامة للتطبيق.

- `core/constants/`
  - `app_constants.dart`
    - يحتوي مسارات التنقل (`RoutePaths`) وأسماء الشاشات (`RouteNames`).
    - يعرّف ثوابت عامة مثل أوقات التحريك وقيم افتراضية للبطارية.
    - يعرّف مفاتيح التخزين لـ `SharedPreferences`.

- `core/navigation/`
  - `app_router.dart`
    - يعرّف مسارات التطبيق باستخدام `go_router`.
    - يحتوي `Splash`, `Onboarding`, وShell رئيسي بأربعة فروع: Dashboard، Lighting، Sound، Battery.
    - يضيف شاشات خارجية مثل Settings، Debug، Profile.
    - يربط كل شاشة بمسار محدد ورمز انتقال.

- `core/services/`
  - `communication_service.dart`
    - يعرّف واجهة `CommunicationService` العامة لجميع طرق الاتصال.
    - يحتوي ثلاث طبقات: BLE، WiFi، WebSocket.
    - حاليًا كلها `TODO` ولم تُبنَ بعد؛ هي قشرة جاهزة للاعتماد على بروتوكولات اتصال فعلية.

- `core/theme/`
  - يحتوي السمات والألوان المشتركة للتطبيق.
  - يستخدم هذا المجلد لتوحيد شكل الواجهة عبر الشاشات.

- `core/utils/`
  - helpers ومساعدات قد يستخدمها التطبيق.

- `core/widgets/`
  - `app_shell.dart`
    - يبني الشريط السفلي العائم والشاشة الرئيسية الحافظة للحالة.
    - يعرض تنبيه حالة الاتصال عندما يفقد التطبيق الاتصال.
  - `animated_status_dot.dart`, `glass_card.dart`, `gradient_button.dart`
    - عناصر واجهة مستخدم مشتركة قابلة لإعادة الاستخدام.

### `lib/device/`

الطبقة المسؤولة عن التحكم في الجهاز الفعلي أو المحاكاة.

- `umbrella_device_interface.dart`
  - يعرّف الواجهة العامة للجهاز الذكي.
  - يضم أوامر مثل `connect()`, `disconnect()`, `openUmbrella()`, `closeUmbrella()`, `toggleLight()`, `setRGBColor()`, `playMusic()`, `pauseMusic()`.
  - يعرّف أخطاء خاصة بالجهاز مثل `DeviceNotConnectedException` و `UmbrellaOperationException`.

- `fake_umbrella_device.dart`
  - نموذج محاكاة للتطوير والاختبار.
  - يتيح تشغيل التطبيق دون جهاز فعلي.

- `esp32_umbrella_device.dart`
  - هيكل مخصص لدعم الاتصال الفعلي عبر ESP32.
  - حاليًا على الأرجح غير مكتمل أو قيد التطوير.

- `models/umbrella_state.dart`
  - يعرّف موديلات الحالة العامة:
    - `UmbrellaDeviceState`
    - `BatteryState`
    - `LightingState`
    - `SoundState`
  - يحدّد حالات الاتصال، وضع المظلة، حالة الشحن، الألوان، مستوى الصوت.

### `lib/state/`

حيث تتم إدارة حالة التطبيق باستخدام Riverpod.

- `device_provider.dart`
  - يحدّد `simulationModeProvider` لتشغيل المحاكاة أو الجهاز الحقيقي.
  - يعيد `deviceProvider` الكائن الفعلي من `FakeUmbrellaDevice` أو `ESP32UmbrellaDevice`.
  - يوفر تدفق الحالة `deviceStateStreamProvider` و `currentDeviceStateProvider`.
  - يحسب حالة الاتصال `isConnectedProvider`.
  - يحتوي `DeviceConnectionNotifier` لإدارة الاتصال.

- `battery_provider.dart`, `lighting_provider.dart`, `sound_provider.dart`, `umbrella_provider.dart`, `theme_provider.dart`, `user_profile.dart`
  - كل منها مسؤول عن جزء منفصل من حالة التطبيق.
  - `battery_provider` يتابع مستوى البطارية وشحن الطاقة الشمسية.
  - `lighting_provider` ينظم حالة الإضاءة، مستوى السطوع، وضع الإضاءة.
  - `sound_provider` ينظم حالة الصوت وتشغيل الموسيقى.
  - `theme_provider` يحدد وضع الثيم (فاتح/داكن).

### `lib/features/`

كل مجلد هنا يمثل شاشة أو مجموعة شاشات.

- `dashboard/`
  - `presentation/dashboard_screen.dart`
    - الشاشة الرئيسية للتطبيق.
    - تعرض حالة الاتصال، معلومات البطارية، بطاقات التحكم السريع، ومشهد المظلة.
    - تستدعي `deviceConnectionProvider.notifier.connect()` عند العرض.
  - `widgets/`
    - تشمل بطاقات: `umbrella_control_card.dart`, `quick_control_card.dart`, `battery_status_card.dart`, `companion_message_banner.dart`.

- `lighting/`
  - `presentation/lighting_screen.dart`
    - شاشة التحكم في الإضاءة.
    - تعتمد على `lightingStateProvider` و `lightingControlProvider`.

- `sound/`
  - `presentation/sound_screen.dart`
    - شاشة التحكم في تشغيل الصوت ومستوى الصوت.

- `battery/`
  - `presentation/battery_screen.dart`
    - شاشة عرض معلومات البطارية وحالة الطاقة الشمسية.

- `settings/`
  - `presentation/settings_screen.dart`
    - إعدادات التطبيق مثل الوضع الليلي أو تغيير الوضع.

- `profile/`
  - `presentation/profile_screen.dart`
    - شاشة ملفات المستخدم الشخصية.

- `onboarding/`
  - `presentation/onboarding_screen.dart`
    - شاشة تقديم التطبيق للمستخدم الجديد.

- `debug/`
  - `presentation/debug_screen.dart`
    - شاشة أدوات مصممة للمطورين أو لفحص الحالة.

### `lib/page/`

- `splash.dart`
  - شاشة البداية (Splash Screen).
  - تستخدم قبل الانتقال إلى الشاشة الرئيسية أو شاشة الترحيب.

---

## علاقة المجلدات ببعضها

- `main.dart` يعتمد على `core/navigation/app_router.dart` و `core/theme/app_theme.dart` و `state/theme_provider.dart`.
- `app_router.dart` يربط الشاشات الموجودة في `lib/features/*` بمسارات التنقل.
- `AppShell` في `core/widgets/app_shell.dart` يعرض شريط التنقل السفلي ويحتفظ بحالة المظهر عبر الشاشات.
- `lib/state/device_provider.dart` يربط بين واجهة الجهاز `lib/device/umbrella_device_interface.dart` والشاشات التي تعرض الحالة.
- الشاشات في `lib/features/dashboard/` و `lib/features/battery/` و `lib/features/lighting/` و `lib/features/sound/` تستخدم جميعًا مزودات الحالة في `lib/state/` لتحديث العرض.
- `lib/device/models/umbrella_state.dart` هو المصدر المشترك لحالة الجهاز ويستخدمه كل من `device_provider.dart` وواجهات الأجهزة.

---

## ملاحظات مهمة

- التطبيق يستخدم Riverpod لإدارة الحالة بشكل مركزي.
- `FakeUmbrellaDevice` يبدو فعالًا لتشغيل التطبيق بدون جهاز فعلي.
- `communication_service.dart` هو طبقة تهيئة اتصال لكنها غير مكتملة بعد (`TODO`).
- التنقل يعتمد على `go_router` مع `StatefulShellRoute` لتوفير شريط تنقل ثابت بين الشاشات الرئيسية.
- التطبيق يبدو حديثًا من ناحية تصميم الواجهة، مع تأثيرات `flutter_animate` وواجهة مستخدم أنيقة.

---

## توصية بسيطة

إذا تريد توثيقًا أعمق لكل ملف داخل `lib/core/` أو `lib/features/`، فأستطيع أن أضيف قائمة كاملة لكل ملف `.dart` مع شرح صغير لوظيفة الملف وارتباطه بالمشروع.
