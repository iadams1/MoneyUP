class OtherHelpers {
  static String maskEmail(String email) {
  final parts = email.split('@');

  if (parts.length != 2) return email; // safety fallback

  final username = parts[0];
  final domain = parts[1];

  if (username.length <= 2) {
    return '${username[0]}*@$domain';
  }

  final visible = username.substring(0, 2);
  final masked = '*' * (username.length - 2);

  return '$visible$masked@$domain';
}
}