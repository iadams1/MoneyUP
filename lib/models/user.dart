class User {
  final dynamic userId;
  final String fullName;
  final String username;
  final int userProfileId;

  final String? email;

  const User({
    required this.userId,
    required this.fullName,
    required this.username,
    required this.userProfileId,
    this.email,
  });

  factory User.fromJSON(Map<String, dynamic> json) {
    return User(
        userId: json['id'],
        fullName: json['full_name'] as String,
        username: json['username'] as String,
        userProfileId: json['icon_id'] as int,
        email: json['email'] as String?,
    );
  }
}