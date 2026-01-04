import 'package:vizinhanca_solidaria/address/domain/entities/address.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String? avatar;
  final String token;
  final String username;
  final List<Address> address;
  // ... outros atributos relevantes

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    required this.token,
    required this.username,
    required this.address,
    // ... outros atributos
  });

  factory User.fromJsonWithAddress(Map<String, dynamic> json) {
    Map<String, dynamic> user = json['user'] as Map<String, dynamic>;
    print(user);
    List<dynamic> address = user['address'] as List<dynamic>;
    print(address);

    return User(
      id: user['id'] ?? 0,
      name: user['name'] ?? '',
      email: user['email'] ?? '',
      avatar: user['avatar'] ?? '',
      token: json['access_token'] ?? '',
      username: user['username'] ?? '',
      address: address.map((address) {
        return Address.fromJson(address as Map<String, dynamic>);
      }).toList(),
      // ... mapear outros atributos
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? '',
      token: json['access_token'] ?? '',
      username: json['username'] ?? '',
      address: [],
      // ... mapear outros atributos
    );
  }

  factory User.fromJsonRegister(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['nome'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      token: '',
      address: [],
      // ... mapear outros atributos
    );
  }

  // Métodos para manipular os dados do usuário, se necessário
}
