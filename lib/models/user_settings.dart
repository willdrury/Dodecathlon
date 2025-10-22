enum ThemeMode {
  system,
  light,
  dark,
}

ThemeMode stringToTheme(String theme) {
  if (theme == 'system') {
    return ThemeMode.system;
  } else if (theme == 'light') {
    return ThemeMode.light;
  } else if (theme == 'dark') {
    return ThemeMode.dark;
  }
  return ThemeMode.system;
}

class UserSettings {
  ThemeMode theme;
  bool commentNotifications;
  bool likeNotifications;
  bool newChallengeNotifications;
  bool leaderboardUpdateNotifications;
  bool challengeReminders;

  UserSettings({
    required this.theme,
    required this.commentNotifications,
    required this.likeNotifications,
    required this.newChallengeNotifications,
    required this.leaderboardUpdateNotifications,
    required this.challengeReminders,
  });
}