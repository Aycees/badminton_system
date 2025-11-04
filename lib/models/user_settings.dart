class UserSettings {
  String defaultCourtName;
  double defaultCourtRate;
  double defaultShuttleCockPrice;
  bool divideCourtEqually;

  UserSettings({
    this.defaultCourtName = 'Main Court',
    this.defaultCourtRate = 100.0,
    this.defaultShuttleCockPrice = 20.0,
    this.divideCourtEqually = true,
  });

  // Singleton pattern to access settings throughout the app
  static final UserSettings _instance = UserSettings();
  static UserSettings get instance => _instance;
}
