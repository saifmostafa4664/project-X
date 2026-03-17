/// Smart Umbrella App - Battery Provider
///
/// Riverpod providers for battery and solar monitoring including
/// percentage, charging status, and companion messages.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../device/models/umbrella_state.dart';
import '../core/constants/app_constants.dart';
import 'device_provider.dart';

/// Provider for current battery state
final batteryStateProvider = Provider<BatteryState>((ref) {
  final asyncState = ref.watch(deviceStateStreamProvider);
  return asyncState.when(
    data: (state) => state.battery,
    loading: () => const BatteryState(),
    error: (_, __) => const BatteryState(),
  );
});

/// Provider for battery percentage
final batteryPercentageProvider = Provider<int>((ref) {
  return ref.watch(batteryStateProvider).percentage;
});

/// Provider for charging status
final chargingStatusProvider = Provider<ChargingStatus>((ref) {
  return ref.watch(batteryStateProvider).chargingStatus;
});

/// Provider for solar power output
final solarPowerProvider = Provider<double>((ref) {
  return ref.watch(batteryStateProvider).solarPowerWatts;
});

/// Provider for solar active status
final isSolarActiveProvider = Provider<bool>((ref) {
  return ref.watch(batteryStateProvider).isSolarActive;
});

/// Provider for low battery warning
final isLowBatteryProvider = Provider<bool>((ref) {
  return ref.watch(batteryStateProvider).isLow;
});

/// Provider for critical battery warning
final isCriticalBatteryProvider = Provider<bool>((ref) {
  return ref.watch(batteryStateProvider).isCritical;
});

/// Provider for strong sunlight detection
final hasStrongSunlightProvider = Provider<bool>((ref) {
  return ref.watch(batteryStateProvider).hasStrongSunlight;
});

/// Provider for companion messages based on current state
final companionMessagesProvider = Provider<List<CompanionMessage>>((ref) {
  final battery = ref.watch(batteryStateProvider);
  final lighting = ref
      .watch(deviceStateStreamProvider)
      .when(
        data: (state) => state.lighting,
        loading: () => const LightingState(),
        error: (_, __) => const LightingState(),
      );

  final messages = <CompanionMessage>[];
  final now = DateTime.now();

  // Battery charging well
  if (battery.chargingStatus == ChargingStatus.charging &&
      battery.solarPowerWatts > 20) {
    messages.add(
      CompanionMessage(
        message: AppStrings.batteryChargingWell,
        type: CompanionMessageType.success,
        timestamp: now,
      ),
    );
  }

  // Strong sunlight detected
  if (battery.hasStrongSunlight) {
    messages.add(
      CompanionMessage(
        message: AppStrings.strongSunlight,
        type: CompanionMessageType.info,
        timestamp: now,
      ),
    );
  }

  // Low battery warning
  if (battery.isLow && !battery.isCritical) {
    messages.add(
      CompanionMessage(
        message: AppStrings.lowBattery,
        type: CompanionMessageType.warning,
        timestamp: now,
      ),
    );
  }

  // Critical battery
  if (battery.isCritical) {
    messages.add(
      CompanionMessage(
        message: '⚠️ Battery critically low! Please charge.',
        type: CompanionMessageType.error,
        timestamp: now,
      ),
    );
  }

  // Power saving suggestion
  if (battery.isLow && lighting.isOn) {
    messages.add(
      CompanionMessage(
        message: AppStrings.savePowerSuggestion,
        type: CompanionMessageType.tip,
        timestamp: now,
      ),
    );
  }

  return messages;
});

/// Provider for the most important companion message to display
final primaryCompanionMessageProvider = Provider<CompanionMessage?>((ref) {
  final messages = ref.watch(companionMessagesProvider);
  if (messages.isEmpty) return null;

  // Priority: error > warning > tip > info > success
  const priority = [
    CompanionMessageType.error,
    CompanionMessageType.warning,
    CompanionMessageType.tip,
    CompanionMessageType.info,
    CompanionMessageType.success,
  ];

  for (final type in priority) {
    final message = messages.where((m) => m.type == type).firstOrNull;
    if (message != null) return message;
  }

  return messages.first;
});

/// Provider for battery icon based on percentage and charging status
final batteryIconDataProvider = Provider<BatteryIconData>((ref) {
  final percentage = ref.watch(batteryPercentageProvider);
  final status = ref.watch(chargingStatusProvider);
  final isCharging = status == ChargingStatus.charging;

  String iconName;
  if (percentage >= 90) {
    iconName = isCharging ? 'battery_charging_full' : 'battery_full';
  } else if (percentage >= 60) {
    iconName = isCharging ? 'battery_charging_80' : 'battery_5_bar';
  } else if (percentage >= 40) {
    iconName = isCharging ? 'battery_charging_60' : 'battery_4_bar';
  } else if (percentage >= 20) {
    iconName = isCharging ? 'battery_charging_30' : 'battery_2_bar';
  } else {
    iconName = isCharging ? 'battery_charging_20' : 'battery_1_bar';
  }

  return BatteryIconData(
    iconName: iconName,
    isCharging: isCharging,
    isLow: percentage <= 20,
    isCritical: percentage <= 10,
  );
});

/// Data class for battery icon display
class BatteryIconData {
  final String iconName;
  final bool isCharging;
  final bool isLow;
  final bool isCritical;

  const BatteryIconData({
    required this.iconName,
    required this.isCharging,
    required this.isLow,
    required this.isCritical,
  });
}
