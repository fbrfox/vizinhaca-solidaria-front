class LoginDto {
  final String username;
  final String password;
  final bool remember;

  LoginDto(
      {required this.username, required this.password, required this.remember});

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}
