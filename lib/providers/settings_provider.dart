import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:dodecathlon/models/user_settings.dart';
import 'package:flutter_riverpod/legacy.dart';
// import 'package:path_provider/path_provider.dart' as syspaths;

Future<Database?> _getDatabase() async {
  if (kIsWeb) {
    return null;
  } else {
    print('getting DB');
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
              'challenge_reminders INTEGER, '
              'last_login_date INTEGER'
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
    print('loading user settings');

    // Uncomment below to update table
    // String userId = FirebaseAuth.instance.currentUser!.uid;
    // Map<dynamic, dynamic> defaultSettings = {
    //   'theme': ThemeMode.system.name,
    //   'comment_notifications': 1,
    //   'like_notifications': 1,
    //   'new_challenge_notifications': 1,
    //   'leaderboard_update_notifications': 1,
    //   'challenge_reminders': 1,
    //   'last_login_date': DateTime.now().microsecondsSinceEpoch,
    //   'id': userId,
    // };
    // await createSettings(defaultSettings);
    // End update section

    final data = await db!.query('user_settings');
    final settings = data.map((row) {
      return {
        'theme': row['theme'] as String,
        'comment_notifications': (row['comment_notifications'] as int) == 1 ? true : false,
        'like_notifications': (row['like_notifications'] as int) == 1 ? true : false,
        'new_challenge_notifications': (row['new_challenge_notifications'] as int) == 1 ? true : false,
        'leaderboard_update_notifications': (row['leaderboard_update_notifications'] as int) == 1 ? true : false,
        'challenge_reminders': (row['challenge_reminders'] as int) == 1 ? true : false,
        'last_login_date': DateTime.fromMicrosecondsSinceEpoch(row['last_login_date'] as int),
        'id': row['id'] as String,
      };
    }).toList();

    print('user settings: $settings');
    if (settings != null && settings.isNotEmpty) {
      state = settings[0];
    } else {
      print('creating default settings');
      String userId = FirebaseAuth.instance.currentUser!.uid;
      Map<dynamic, dynamic> defaultSettings = {
        'theme': ThemeMode.system.name,
        'comment_notifications': 1,
        'like_notifications': 1,
        'new_challenge_notifications': 1,
        'leaderboard_update_notifications': 1,
        'challenge_reminders': 1,
        'last_login_date': DateTime.now().microsecondsSinceEpoch,
        'id': userId,
      };
      await createSettings(defaultSettings);
      state = defaultSettings;
    }
  }

  Future<void> updateSettings(Map<dynamic, dynamic> settings) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final Database? db = await _getDatabase();

    await db!.update('user_settings', {
      'theme': settings['theme'],
      'comment_notifications': settings['comment_notifications'] ? 1 : 0,
      'like_notifications': settings['like_notifications'] ? 1 : 0,
      'new_challenge_notifications': settings['new_challenge_notifications'] ? 1 : 0,
      'leaderboard_update_notifications': settings['leaderboard_update_notifications'] ? 1 : 0,
      'challenge_reminders': settings['challenge_reminders'] ? 1 : 0,
      'last_login_date': DateTime.now().microsecondsSinceEpoch,
      'id': userId,
    }, where: 'id = ?', whereArgs: [userId]);
    state = settings;
  }

  Future<void> createSettings(Map<dynamic, dynamic> settings) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final Database? db = await _getDatabase();
    if (db == null) return;

    // db.execute('DROP TABLE IF EXISTS user_settings');
    // db.execute('CREATE TABLE user_settings('
    //     'id TEXT PRIMARY KEY, '
    //     'theme TEXT, '
    //     'comment_notifications INTEGER, '
    //     'like_notifications INTEGER, '
    //     'new_challenge_notifications INTEGER, '
    //     'leaderboard_update_notifications INTEGER, '
    //     'challenge_reminders INTEGER, '
    //     'last_login_date INTEGER'
    //     ')'
    // );

    await db.insert('user_settings', {
      'theme': settings['theme'],
      'comment_notifications': settings['comment_notifications'],
      'like_notifications': settings['like_notifications'],
      'new_challenge_notifications': settings['new_challenge_notifications'],
      'leaderboard_update_notifications': settings['leaderboard_update_notifications'],
      'challenge_reminders': settings['challenge_reminders'],
      'last_login_date': settings['last_login_date'],
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