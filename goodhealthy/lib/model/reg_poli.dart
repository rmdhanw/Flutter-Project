import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:goodhealthy/util/config.dart';
import 'package:http/http.dart' as http;
import 'package:goodhealthy/util/session.dart';
import 'package:logger/logger.dart';
import 'pasien.dart';
import 'dokter.dart';

class RegisPoli {
  final String idRegisPoli, tglBooking, poli;
  final Pasien idPasien;
  final Dokter idDokter;

  RegisPoli(
      {required this.idRegisPoli,
      required this.idPasien,
      required this.idDokter,
      required this.tglBooking,
      required this.poli});

  factory RegisPoli.fromJson(Map<String, dynamic> json) {
    return RegisPoli(
        idRegisPoli: json['id_regis_poli'].toString(),
        idPasien: Pasien.fromJson(json['id_pasien']),
        idDokter: Dokter.fromJson(json['id_dokter']),
        tglBooking: json['tgl_booking'],
        poli: json['poli'].toString());
  }
}

List<RegisPoli> regisPoliFromJson(jsonData) {
  List<RegisPoli> result =
      List<RegisPoli>.from(jsonData.map((item) => RegisPoli.fromJson(item)));

  return result;
}

final logger = Logger();

// index (GET)
Future<List<RegisPoli>> fetchRegisPolis() async {
  final prefs = await SharedPreferences.getInstance();
  String idPasien = prefs.getString(ID_PASIEN) ?? "";
  final response = await http.get(Uri.parse(
      'http://10.0.2.2/goodhealth/regis_poli/index.php?id_pasien=$idPasien'));

  if (response.statusCode == 200) {
    var jsonResp = json.decode(response.body);
    return regisPoliFromJson(jsonResp);
  } else {
    logger.e('Failed load, status : ${response.statusCode}');
    throw Exception('Failed load, status : ${response.statusCode}');
  }
}

// create (POST)
Future<http.Response?> regisPoliCreate(RegisPoli regisPoli) async {
  final prefs = await SharedPreferences.getInstance();
  try {
    final response = await http.post(
        Uri.parse('http://10.0.2.2/goodhealth/regis_poli/create.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'id_pasien': prefs.getString(ID_PASIEN),
          'id_dokter': regisPoli.idDokter.idDokter,
          'tgl_booking': regisPoli.tglBooking,
          'poli': regisPoli.poli
        }));

    return response;
  } catch (e) {
    logger.e("Error: ${e.toString()}");
    return null;
  }
}

// delete (GET)
Future deleteRegisPoli(id) async {
  //String route = AppConfig.API_ENDPOINT + "regis-poli/delete.php?id=$id";
  final response = await http.get(
      Uri.parse('http://10.0.2.2/goodhealth/regis_poli/delete.php?id=$id'));

  if (response.statusCode == 200) {
    var jsonResp = json.decode(response.body);
    return jsonResp['message'];
  } else {
    logger.e('Failed load, status : ${response.statusCode}');
    return response.body.toString();
  }
}
