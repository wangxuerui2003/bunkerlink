class User {
  final String id;
  final String nickname;
  final String username;
  final String email;
  String? avatar;

  User({
    required this.id,
    required this.nickname,
    required this.username,
    required this.email,
    this.avatar,
  });

  void setAvatar(String avatarUrl) {
    avatar = avatarUrl;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nickname: json['nickname'],
      username: json['username'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'username': username,
      'email': email,
      'avatar': avatar,
    };
  }
}
