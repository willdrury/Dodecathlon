enum ThemeMode {
  system,
  light,
  dark,
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