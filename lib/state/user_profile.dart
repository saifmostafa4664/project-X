library;

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  final String name;
  final String avatarEmoji;
  final int totalSessions;
  final int totalUsageMinutes;
  final DateTime memberSince;
  final List<SessionRecord> recentSessions;

  const UserProfile({
    required this.name,
    required this.avatarEmoji,
    required this.totalSessions,
    required this.totalUsageMinutes,
    required this.memberSince,
    required this.recentSessions,
  });

  factory UserProfile.defaultProfile() => UserProfile(
        name: 'Captain',
        avatarEmoji: '🏖️',
        totalSessions: 0,
        totalUsageMinutes: 0,
        memberSince: DateTime.now(),
        recentSessions: [],
      );

  UserProfile copyWith({
    String? name,
    String? avatarEmoji,
    int? totalSessions,
    int? totalUsageMinutes,
    List<SessionRecord>? recentSessions,
  }) =>
      UserProfile(
        name: name ?? this.name,
        avatarEmoji: avatarEmoji ?? this.avatarEmoji,
        totalSessions: totalSessions ?? this.totalSessions,
        totalUsageMinutes: totalUsageMinutes ?? this.totalUsageMinutes,
        memberSince: memberSince,
        recentSessions: recentSessions ?? this.recentSessions,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'avatarEmoji': avatarEmoji,
        'totalSessions': totalSessions,
        'totalUsageMinutes': totalUsageMinutes,
        'memberSince': memberSince.toIso8601String(),
        'recentSessions': recentSessions.map((s) => s.toJson()).toList(),
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: json['name'] as String? ?? 'Captain',
        avatarEmoji: json['avatarEmoji'] as String? ?? '🏖️',
        totalSessions: json['totalSessions'] as int? ?? 0,
        totalUsageMinutes: json['totalUsageMinutes'] as int? ?? 0,
        memberSince: DateTime.tryParse(json['memberSince'] as String? ?? '') ??
            DateTime.now(),
        recentSessions: (json['recentSessions'] as List<dynamic>? ?? [])
            .map((e) => SessionRecord.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class SessionRecord {
  final DateTime date;
  final int durationMinutes;
  final String mode;

  const SessionRecord({
    required this.date,
    required this.durationMinutes,
    required this.mode,
  });

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'durationMinutes': durationMinutes,
        'mode': mode,
      };

  factory SessionRecord.fromJson(Map<String, dynamic> json) => SessionRecord(
        date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
        durationMinutes: json['durationMinutes'] as int? ?? 0,
        mode: json['mode'] as String? ?? 'Beach',
      );
}

const _kProfileKey = 'user_profile_v1';

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier() : super(UserProfile.defaultProfile()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kProfileKey);
      if (raw != null) {
        state = UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('Failed to load user profile: $e');
      state = UserProfile.defaultProfile();
    }
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kProfileKey, jsonEncode(state.toJson()));
    } catch (e) {
      debugPrint('Failed to save user profile: $e');
    }
  }

  Future<void> updateName(String name) async {
    if (name.trim().isEmpty) return;
    state = state.copyWith(name: name.trim());
    await _save();
  }

  Future<void> updateAvatar(String emoji) async {
    state = state.copyWith(avatarEmoji: emoji);
    await _save();
  }

  Future<void> addSession({
    required int durationMinutes,
    required String mode,
  }) async {
    final sessions = [
      SessionRecord(date: DateTime.now(), durationMinutes: durationMinutes, mode: mode),
      ...state.recentSessions,
    ].take(10).toList();

    state = state.copyWith(
      totalSessions: state.totalSessions + 1,
      totalUsageMinutes: state.totalUsageMinutes + durationMinutes,
      recentSessions: sessions,
    );
    await _save();
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>(
  (ref) => UserProfileNotifier(),
);
