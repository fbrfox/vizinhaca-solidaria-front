class RegisterDto {
  final String username;
  final String email;
  final String password;
  final String name;
  final String? avatar;
  final String? appleToken;
  final String? googleToken;

  RegisterDto({
    required this.username,
    required this.email,
    required this.password,
    required this.name,
    this.avatar,
    this.appleToken,
    this.googleToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'nome': name,
      'email': email,
      'password': password,
      'avatar': avatar,
      'appleToken': appleToken,
      'googleToken': googleToken,
    };
  }
}
