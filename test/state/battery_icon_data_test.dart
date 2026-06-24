import 'package:flutter_test/flutter_test.dart';
import 'package:usmart/state/battery_provider.dart';

void main() {
  group('BatteryIconData', () {
    test('stores all fields correctly', () {
      const data = BatteryIconData(
        iconName: 'battery_full',
        isCharging: false,
        isLow: false,
        isCritical: false,
      );

      expect(data.iconName, 'battery_full');
      expect(data.isCharging, false);
      expect(data.isLow, false);
      expect(data.isCritical, false);
    });

    test('charging state is stored correctly', () {
      const data = BatteryIconData(
        iconName: 'battery_charging_full',
        isCharging: true,
        isLow: false,
        isCritical: false,
      );

      expect(data.isCharging, true);
    });

    test('low battery state', () {
      const data = BatteryIconData(
        iconName: 'battery_1_bar',
        isCharging: false,
        isLow: true,
        isCritical: false,
      );

      expect(data.isLow, true);
      expect(data.isCritical, false);
    });

    test('critical battery state', () {
      const data = BatteryIconData(
        iconName: 'battery_1_bar',
        isCharging: false,
        isLow: true,
        isCritical: true,
      );

      expect(data.isLow, true);
      expect(data.isCritical, true);
    });
  });
}
