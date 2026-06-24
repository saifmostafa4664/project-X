import 'package:flutter_test/flutter_test.dart';
import 'package:usmart/core/constants/app_constants.dart';

void main() {
  group('AnimationDurations', () {
    test('durations are in ascending order', () {
      expect(
        AnimationDurations.fast.inMilliseconds <
            AnimationDurations.normal.inMilliseconds,
        true,
      );
      expect(
        AnimationDurations.normal.inMilliseconds <
            AnimationDurations.slow.inMilliseconds,
        true,
      );
      expect(
        AnimationDurations.slow.inMilliseconds <
            AnimationDurations.splash.inMilliseconds,
        true,
      );
    });

    test('durations have expected values', () {
      expect(AnimationDurations.fast, const Duration(milliseconds: 150));
      expect(AnimationDurations.normal, const Duration(milliseconds: 300));
      expect(AnimationDurations.slow, const Duration(milliseconds: 500));
      expect(AnimationDurations.splash, const Duration(milliseconds: 2000));
      expect(
        AnimationDurations.stateChange,
        const Duration(milliseconds: 800),
      );
    });
  });

  group('DefaultValues', () {
    test('volume is 50', () {
      expect(DefaultValues.volume, 50);
    });

    test('brightness is 70', () {
      expect(DefaultValues.brightness, 70);
    });

    test('batteryLow is 20', () {
      expect(DefaultValues.batteryLow, 20);
    });

    test('batteryFull is 100', () {
      expect(DefaultValues.batteryFull, 100);
    });

    test('solarThreshold is 30.0', () {
      expect(DefaultValues.solarThreshold, 30.0);
    });
  });

  group('AppStrings', () {
    test('appName is non-empty', () {
      expect(AppStrings.appName.isNotEmpty, true);
    });

    test('appTagline is non-empty', () {
      expect(AppStrings.appTagline.isNotEmpty, true);
    });

    test('all status messages are non-empty', () {
      expect(AppStrings.batteryChargingWell.isNotEmpty, true);
      expect(AppStrings.strongSunlight.isNotEmpty, true);
      expect(AppStrings.lowBattery.isNotEmpty, true);
      expect(AppStrings.savePowerSuggestion.isNotEmpty, true);
      expect(AppStrings.deviceOffline.isNotEmpty, true);
      expect(AppStrings.deviceConnected.isNotEmpty, true);
      expect(AppStrings.umbrellaOpening.isNotEmpty, true);
      expect(AppStrings.umbrellaClosing.isNotEmpty, true);
    });
  });

  group('RouteNames', () {
    test('all route names are non-empty strings', () {
      final names = [
        RouteNames.splash,
        RouteNames.onboarding,
        RouteNames.dashboard,
        RouteNames.lighting,
        RouteNames.sound,
        RouteNames.battery,
        RouteNames.settings,
        RouteNames.debug,
        RouteNames.profile,
      ];
      for (final name in names) {
        expect(name.isNotEmpty, true);
      }
    });
  });

  group('RoutePaths', () {
    test('all route paths start with /', () {
      final paths = [
        RoutePaths.splash,
        RoutePaths.onboarding,
        RoutePaths.dashboard,
        RoutePaths.lighting,
        RoutePaths.sound,
        RoutePaths.battery,
        RoutePaths.settings,
        RoutePaths.debug,
        RoutePaths.profile,
      ];
      for (final path in paths) {
        expect(path.startsWith('/'), true);
      }
    });

    test('dashboard is root path', () {
      expect(RoutePaths.dashboard, '/');
    });
  });

  group('StorageKeys', () {
    test('all storage keys are non-empty and unique', () {
      final keys = [
        StorageKeys.hasCompletedOnboarding,
        StorageKeys.simulationModeEnabled,
        StorageKeys.themeMode,
        StorageKeys.lastConnectedDeviceId,
      ];
      expect(keys.toSet().length, keys.length);
      for (final key in keys) {
        expect(key.isNotEmpty, true);
      }
    });
  });
}
