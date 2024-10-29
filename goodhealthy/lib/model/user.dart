import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class User {
  final String username, password, idUser, idPasien;

  User(
      {required this.username,
      required this.password,
      required this.idUser,
      required this.idPasien});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        idUser: json['id_user'].toString(),
        username: json['username'],
        password: json['password'],
        idPasien: json['id_pasien'].toString());
  }
}

final logger = Logger();

// login (POST)
Future<Response?> login(User user) async {
  try {
    final response = await http.post(
        Uri.parse('http://10.0.2.2/goodhealth/login.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'username': user.username,
          'password': user.password,
          'idPasien': user.idPasien
        }));

    logger.i('Response status: ${response.statusCode}');
    logger.i('Response body: ${response.body}');
    return response;
  } catch (e) {
    print("Error : ${e.toString()}");
    return null;
  }
}
