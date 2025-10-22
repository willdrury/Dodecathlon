import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:dodecathlon/models/user_settings.dart';
import 'package:flutter_riverpod/legacy.dart';

Future<Database?> _getDatabase() async {
  if (kIsWeb) {
    print('On web');
    return null;
  } else {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'dodecathlon.db'),
        onCreate: (db, version) {
          db.execute('CREATE TABLE user_settings('
              'id TEXT PRIMARY KEY, '
              'theme TEXT, '
              'comment_notifications INTEGER, '
              'like_notifications INTEGER, '
              'new_challenge_notifications INTEGER, '
              'leaderboard_update_notifications INTEGER, '
              'challenge_reminders INTEGER'
              ')'
          );
        },
        version: 1
    );
  }
}

class SettingsProvider extends StateNotifier<Map<dynamic, dynamic>> {
  SettingsProvider() : super({});

  Future<void> loadSettings() async {
    final Database? db = await _getDatabase();

    // On Web
    // if (db == null) {
    //   final _localStorage = window.localStorage;
    //
    //   // Create local settings
    //   if (_localStorage['id'] == null) {
    //     _localStorage['theme'] = ThemeMode.system.name;
    //     _localStorage['comment_notifications'] = 'true';
    //     _localStorage['like_notifications'] = 'true';
    //     _localStorage['new_challenge_notifications'] = 'true';
    //     _localStorage['leaderboard_update_notifications'] = 'true';
    //     _localStorage['challenge_reminders'] = 'true';
    //     _localStorage['id'] = '1';
    //   }
    //
    //   state = {
    //     'theme': _localStorage['theme'],
    //     'comment_notifications': _localStorage['comment_notifications'] == 'true',
    //     'like_notifications': _localStorage['like_notifications'] == 'true',
    //     'new_challenge_notifications': _localStorage['new_challenge_notifications'] == 'true',
    //     'leaderboard_update_notifications': _localStorage['leaderboard_update_notifications'] == 'true',
    //     'challenge_reminders': _localStorage['challenge_reminders'] == 'true',
    //     'id': _localStorage['id'],
    //   };
    //
    //   return;
    // }

    // Not on web
    final data = await db!.query('user_settings');
    final settings = data.map((row) {
      return {
        'theme': row['theme'] as String,
        'comment_notifications': (row['comment_notifications'] as int) == 1 ? true : false,
        'like_notifications': (row['like_notifications'] as int) == 1 ? true : false,
        'new_challenge_notifications': (row['new_challenge_notifications'] as int) == 1 ? true : false,
        'leaderboard_update_notifications': (row['leaderboard_update_notifications'] as int) == 1 ? true : false,
        'challenge_reminders': (row['challenge_reminders'] as int) == 1 ? true : false,
        'id': row['id'] as String,
      };
    }).toList();

    if (settings.isNotEmpty) {
      state = settings[0];
    } else {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      Map<dynamic, dynamic> defaultSettings = {
        'theme': ThemeMode.system.name,
        'comment_notifications': 1,
        'like_notifications': 1,
        'new_challenge_notifications': 1,
        'leaderboard_update_notifications': 1,
        'challenge_reminders': 1,
        'id': userId,
      };
      await createSettings(defaultSettings);
      state = defaultSettings;
    }
  }

  Future<void> updateSettings(Map<dynamic, dynamic> settings) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final Database? db = await _getDatabase();

    // On Web
    // if (db == null) {
    //   final _localStorage = window.localStorage;
    //
    //   _localStorage['theme'] = settings['theme'];
    //   _localStorage['comment_notifications'] = settings['comment_notifications'] ? 'true' : 'false';
    //   _localStorage['like_notifications'] = settings['like_notifications'] ? 'true' : 'false';
    //   _localStorage['new_challenge_notifications'] = settings['new_challenge_notifications'] ? 'true' : 'false';
    //   _localStorage['leaderboard_update_notifications'] = settings['leaderboard_update_notifications'] ? 'true' : 'false';
    //   _localStorage['challenge_reminders'] = settings['challenge_reminders'] ? 'true' : 'false';
    //   _localStorage['id'] = userId;
    //
    //   state = settings;
    //   return;
    // }

    await db!.update('user_settings', {
      'theme': settings['theme'],
      'comment_notifications': settings['comment_notifications'] ? 1 : 0,
      'like_notifications': settings['like_notifications'] ? 1 : 0,
      'new_challenge_notifications': settings['new_challenge_notifications'] ? 1 : 0,
      'leaderboard_update_notifications': settings['leaderboard_update_notifications'] ? 1 : 0,
      'challenge_reminders': settings['challenge_reminders'] ? 1 : 0,
      'id': userId,
    }, where: 'id = ?', whereArgs: [userId]);
    state = settings;
  }

  Future<void> createSettings(Map<dynamic, dynamic> settings) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final Database? db = await _getDatabase();
    if (db == null) return;

    await db.insert('user_settings', {
      'theme': settings['theme'],
      'comment_notifications': settings['comment_notifications'],
      'like_notifications': settings['like_notifications'],
      'new_challenge_notifications': settings['new_challenge_notifications'],
      'leaderboard_update_notifications': settings['leaderboard_update_notifications'],
      'challenge_reminders': settings['challenge_reminders'],
      'id': userId,
    });

    state = settings;
  }
}

final settingsProvider = StateNotifierProvider<SettingsProvider, Map<dynamic, dynamic>>((ref) {
  SettingsProvider provider = SettingsProvider();
  provider.loadSettings();
  return provider;
});