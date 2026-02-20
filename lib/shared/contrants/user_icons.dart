class UserImages {
  // Keep index 12 as your default/fallback icon
  static const List<String> all = [
    'assets/images/userIcon_2.png',
    'assets/images/userIcon_3.png',
    'assets/images/userIcon_4.png',
    'assets/images/userIcon_5.png',
    'assets/images/userIcon_6.png',
    'assets/images/userIcon_7.png',
    'assets/images/userIcon_8.png',
    'assets/images/userIcon_9.png',
    'assets/images/userIcon_10.png',
    'assets/images/userIcon_11.png',
    'assets/images/userIcon_12.png',
    'assets/images/userIcon_13.png',
    'assets/images/userIcon_1.png',
  ];

  static const int defaultId = 12;

  static String byId(int? iconId) {
    final int id = iconId ?? defaultId;
    if (id < 0 || id >= all.length) return all[defaultId];
    return all[id];
  }
}