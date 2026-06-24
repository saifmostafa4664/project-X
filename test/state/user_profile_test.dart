import 'package:flutter_test/flutter_test.dart';
import 'package:usmart/state/user_profile.dart';

void main() {
  group('UserProfile', () {
    test('defaultProfile has expected values', () {
      final profile = UserProfile.defaultProfile();
      expect(profile.name, 'Captain');
      expect(profile.avatarEmoji, '🏖️');
      expect(profile.totalSessions, 0);
      expect(profile.totalUsageMinutes, 0);
      expect(profile.recentSessions, isEmpty);
    });

    test('copyWith preserves unchanged fields', () {
      final profile = UserProfile.defaultProfile();
      final updated = profile.copyWith(name: 'Sailor');

      expect(updated.name, 'Sailor');
      expect(updated.avatarEmoji, profile.avatarEmoji);
      expect(updated.totalSessions, profile.totalSessions);
      expect(updated.memberSince, profile.memberSince);
    });

    test('copyWith replaces all provided fields', () {
      final profile = UserProfile.defaultProfile();
      final sessions = [
        SessionRecord(
          date: DateTime(2026, 1, 1),
          durationMinutes: 30,
          mode: 'Pool',
        ),
      ];

      final updated = profile.copyWith(
        name: 'Admiral',
        avatarEmoji: '⛱️',
        totalSessions: 5,
        totalUsageMinutes: 150,
        recentSessions: sessions,
      );

      expect(updated.name, 'Admiral');
      expect(updated.avatarEmoji, '⛱️');
      expect(updated.totalSessions, 5);
      expect(updated.totalUsageMinutes, 150);
      expect(updated.recentSessions.length, 1);
    });

    test('toJson / fromJson round-trip', () {
      final profile = UserProfile(
        name: 'TestUser',
        avatarEmoji: '🌊',
        totalSessions: 10,
        totalUsageMinutes: 300,
        memberSince: DateTime(2026, 1, 15),
        recentSessions: [
          SessionRecord(
            date: DateTime(2026, 6, 1),
            durationMinutes: 45,
            mode: 'Beach',
          ),
        ],
      );

      final json = profile.toJson();
      final restored = UserProfile.fromJson(json);

      expect(restored.name, 'TestUser');
      expect(restored.avatarEmoji, '🌊');
      expect(restored.totalSessions, 10);
      expect(restored.totalUsageMinutes, 300);
      expect(restored.memberSince, DateTime(2026, 1, 15));
      expect(restored.recentSessions.length, 1);
      expect(restored.recentSessions.first.durationMinutes, 45);
      expect(restored.recentSessions.first.mode, 'Beach');
    });

    test('fromJson handles missing fields gracefully', () {
      final profile = UserProfile.fromJson(<String, dynamic>{});

      expect(profile.name, 'Captain');
      expect(profile.avatarEmoji, '🏖️');
      expect(profile.totalSessions, 0);
      expect(profile.totalUsageMinutes, 0);
      expect(profile.recentSessions, isEmpty);
    });

    test('fromJson handles null values in fields', () {
      final profile = UserProfile.fromJson({
        'name': null,
        'avatarEmoji': null,
        'totalSessions': null,
        'totalUsageMinutes': null,
        'memberSince': null,
        'recentSessions': null,
      });

      expect(profile.name, 'Captain');
      expect(profile.avatarEmoji, '🏖️');
      expect(profile.totalSessions, 0);
      expect(profile.totalUsageMinutes, 0);
    });
  });

  group('SessionRecord', () {
    test('toJson / fromJson round-trip', () {
      final record = SessionRecord(
        date: DateTime(2026, 3, 20, 14, 30),
        durationMinutes: 60,
        mode: 'Pool',
      );

      final json = record.toJson();
      final restored = SessionRecord.fromJson(json);

      expect(restored.durationMinutes, 60);
      expect(restored.mode, 'Pool');
      expect(restored.date.year, 2026);
      expect(restored.date.month, 3);
      expect(restored.date.day, 20);
    });

    test('fromJson handles missing fields', () {
      final record = SessionRecord.fromJson(<String, dynamic>{});
      expect(record.durationMinutes, 0);
      expect(record.mode, 'Beach');
    });

    test('fromJson handles invalid date', () {
      final record = SessionRecord.fromJson({
        'date': 'not-a-date',
        'durationMinutes': 15,
        'mode': 'Test',
      });
      // Should fall back to DateTime.now() for invalid date
      expect(record.date, isA<DateTime>());
      expect(record.durationMinutes, 15);
      expect(record.mode, 'Test');
    });
  });
}
