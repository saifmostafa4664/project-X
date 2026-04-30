/// Smart Umbrella App - App Constants
///
/// This file contains all application-wide constants including animation
/// durations, default values, and configuration settings.
library;

/// Animation durations used throughout the app
class AnimationDurations {
  const AnimationDurations._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration splash = Duration(milliseconds: 2000);
  static const Duration stateChange = Duration(milliseconds: 800);
}

/// Default values for device controls
class DefaultValues {
  const DefaultValues._();

  static const int volume = 50;
  static const int brightness = 70;
  static const int batteryLow = 20;
  static const int batteryFull = 100;
  static const double solarThreshold =
      30.0; // Watts threshold for "strong sunlight"
}

/// App-wide string constants
class AppStrings {
  const AppStrings._();

  static const String appName = 'Smart Umbrella';
  static const String appTagline = 'Your Intelligent Beach Companion';

  // Companion messages
  static const String batteryChargingWell = 'Battery charging well ☀️';
  static const String strongSunlight = 'Strong sunlight detected';
  static const String lowBattery = 'Battery running low 🔋';
  static const String savePowerSuggestion =
      'Consider turning off lights to save power';
  static const String deviceOffline = 'Device is offline';
  static const String deviceConnected = 'Connected to umbrella';
  static const String umbrellaOpening = 'Opening umbrella...';
  static const String umbrellaClosing = 'Closing umbrella...';
}

/// Route names for navigation
class RouteNames {
  const RouteNames._();

  static const String onboarding = 'onboarding';
  static const String dashboard = 'dashboard';
  static const String lighting = 'lighting';
  static const String sound = 'sound';
  static const String battery = 'battery';
  static const String settings = 'settings';
  static const String debug = 'debug';
  static const String profile = 'profile';
}

/// Route paths for navigation
class RoutePaths {
  const RoutePaths._();

  static const String onboarding = '/onboarding';
  static const String dashboard = '/';
  static const String lighting = '/lighting';
  static const String sound = '/sound';
  static const String battery = '/battery';
  static const String settings = '/settings';
  static const String debug = '/debug';
  static const String profile = '/profile';
}

/// Storage keys for SharedPreferences
class StorageKeys {
  const StorageKeys._();

  static const String hasCompletedOnboarding = 'has_completed_onboarding';
  static const String simulationModeEnabled = 'simulation_mode_enabled';
  static const String themeMode = 'theme_mode';
  static const String lastConnectedDeviceId = 'last_connected_device_id';
}
