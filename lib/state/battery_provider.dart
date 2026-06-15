library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../device/models/umbrella_state.dart';
import '../core/constants/app_constants.dart';
import 'device_provider.dart';

final batteryStateProvider = Provider<BatteryState>((ref) {
  final asyncState = ref.watch(deviceStateStreamProvider);
  return asyncState.when(
    data: (state) => state.battery,
    loading: () => const BatteryState(),
    // ignore: unnecessary_underscores
    error: (_, __) => const BatteryState(),
  );
});

final batteryPercentageProvider = Provider<int>((ref) {
  return ref.watch(batteryStateProvider).percentage;
});

final chargingStatusProvider = Provider<ChargingStatus>((ref) {
  return ref.watch(batteryStateProvider).chargingStatus;
});

final solarPowerProvider = Provider<double>((ref) {
  return ref.watch(batteryStateProvider).solarPowerWatts;
});

final isSolarActiveProvider = Provider<bool>((ref) {
  return ref.watch(batteryStateProvider).isSolarActive;
});

final isLowBatteryProvider = Provider<bool>((ref) {
  return ref.watch(batteryStateProvider).isLow;
});

final isCriticalBatteryProvider = Provider<bool>((ref) {
  return ref.watch(batteryStateProvider).isCritical;
});

final hasStrongSunlightProvider = Provider<bool>((ref) {
  return ref.watch(batteryStateProvider).hasStrongSunlight;
});

final companionMessagesProvider = Provider<List<CompanionMessage>>((ref) {
  final battery = ref.watch(batteryStateProvider);
  final lighting = ref
      .watch(deviceStateStreamProvider)
      .when(
        data: (state) => state.lighting,
        loading: () => const LightingState(),
        // ignore: unnecessary_underscores
        error: (_, __) => const LightingState(),
      );

  final messages = <CompanionMessage>[];
  final now = DateTime.now();

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

  if (battery.hasStrongSunlight) {
    messages.add(
      CompanionMessage(
        message: AppStrings.strongSunlight,
        type: CompanionMessageType.info,
        timestamp: now,
      ),
    );
  }

  if (battery.isLow && !battery.isCritical) {
    messages.add(
      CompanionMessage(
        message: AppStrings.lowBattery,
        type: CompanionMessageType.warning,
        timestamp: now,
      ),
    );
  }

  if (battery.isCritical) {
    messages.add(
      CompanionMessage(
        message: '⚠️ Battery critically low! Please charge.',
        type: CompanionMessageType.error,
        timestamp: now,
      ),
    );
  }

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

final primaryCompanionMessageProvider = Provider<CompanionMessage?>((ref) {
  final messages = ref.watch(companionMessagesProvider);
  if (messages.isEmpty) return null;

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
