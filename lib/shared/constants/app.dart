class App {
  static String version = '1.0.8';
  
  static int databaseVersion = 1;
  static String databaseName = 'mp2_tracker.db';
  static String backupPath = '/storage/emulated/0/Download/MP2Tracker';
  static bool isNewDatabase = false;

  static bool hasUnreadNotification = false;
  static double minimumContribution = 500.0;

  static String notificationChannelId = 'basic_channel';
  static String notificationChannelName = 'MP2 Tracker Channel';
  static String notificationChannelDescription = 'Notifications for MP2 Tracker';

  static String bannerAdUnitId = 'ca-app-pub-5153946521918037/9570119635';
  static String appOpenAdUnitId = 'ca-app-pub-5153946521918037/6943956294';
  static String rewardedAdUnitId = 'ca-app-pub-5153946521918037/2935103104';

  static String testBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static String testAppOpenAdUnitId = 'ca-app-pub-3940256099942544/9257395921';
  static String testRewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';

  // true = contains ads
  // false = ad-free, pro-only features
  static bool isPro = false;

  // true = use testing ad unit ids
  // false = use prod ad unit ids
  static bool isTesting = false;

  // true = drop and create db, adds test data
  // false = creates db if not yet existing
  static bool hasTestData = false;
}