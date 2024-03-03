import 'dart:convert';
import 'package:capstone_sams/models/AccountModel.dart';
import 'package:capstone_sams/models/PrescriptionModel.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants/Env.dart';

class PrescriptionProvider with ChangeNotifier {
  List<Prescription> _prescriptions = [];
  // List<Account> _physicians = [];
  Prescription? _prescription;
  Prescription? get prescription => _prescription;
  List<Prescription> get prescriptions => _prescriptions;
  int? get presNum => _prescription?.presNum;
  int? get acc => _prescription?.account;
  String? get patientID => _prescription?.patientID;

  // Future<List<Prescription>> get prescriptions => Future.value(_prescriptions);
  // Future<List<Account>> get physicians => Future.value(_physicians);

  String _getUrl(String endpoint) {
    return '${Env.prefix}/$endpoint';
  }

  Future<List<Prescription>> fetchPrescriptions(
      String? patientID,  String token) async {
    final header = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.get(
        Uri.parse(
          _getUrl('cpoe/prescription/get-patient/${patientID}/'),
        ),
        headers: header,
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);

        return jsonList.map((json) => Prescription.fromJson(json)).toList();
      } else {
        print(
            'Failed to fetch patient prescriptions ${jsonDecode(response.body)}');
        return [];
      }
    } on Exception catch (e) {
      print('Failed to fetch patient prescriptions. Error: $e');
      return [];
    }
  }

  // Future updatePrescription(
  //     Prescription prescription, String? patientID, String token) async {
  //   final header = <String, String>{
  //     'Content-Type': 'application/json; charset=UTF-8',
  //     'Authorization': 'Bearer $token',
  //   };
  //   try {
  //     final response = await http.put(
  //       Uri.parse(
  //         _getUrl(
  //             'cpoe/prescription/get-prescription/update/${prescription.presNum}'),
  //       ),
  //       headers: header,
  //       body: jsonEncode(prescription),
  //     );

  //     if (response.statusCode == 200) {
  //       fetchPrescriptions(patientID, token);
  //       notifyListeners();
  //     } else {
  //       print('Failed to update prescription');
  //     }
  //   } on Exception catch (e) {
  //     print('Failed to update prescription');
  //   }
  // }

  // Future updatePrescriptionAmount(
  //     Prescription prescription, String? patientID, String token) async {
  //   final header = <String, String>{
  //     'Content-Type': 'application/json; charset=UTF-8',
  //     'Authorization': 'Bearer $token',
  //   };
  //   try {
  //     final response = await http.put(
  //       Uri.parse(
  //         _getUrl(
  //             'cpoe/prescription/get-prescription/update-amount/${prescription.presNum}'),
  //       ),
  //       headers: header,
  //       body: jsonEncode(prescription),
  //     );
  //     if (response.statusCode == 200) {
  //       fetchPrescriptions(patientID, token);
  //       notifyListeners();
  //     } else {
  //       print('Failed to update prescription amount');
  //     }
  //   } on Exception catch (e) {
  //     print('Failed to update prescription amount');
  //   }
  // }

  // Future removePrescription(
  //     Prescription prescription, String? patientID, String token) async {
  //   final header = <String, String>{
  //     'Content-Type': 'application/json; charset=UTF-8',
  //     'Authorization': 'Bearer $token',
  //   };
  //   final body = jsonEncode({'account': prescription.account});
  //   try {
  //     final response = await http.delete(
  //       Uri.parse(_getUrl(
  //           'cpoe/prescription/get-prescription/delete/${prescription.presNum}')),
  //       headers: header,
  //       body: body,
  //     );
  //     if (response.statusCode == 204) {
  //       fetchPrescriptions(patientID, token);
  //     } else {
  //       print('Failed to delete prescription ${jsonDecode(response.body)}');
  //     }
  //   } on Exception catch (e) {
  //     print('Failed to delete prescription. Error: $e');
  //   }
  // }

  // Future removeMedicine(Prescription prescription, String? patientID,
  //     String? drugId, String token) async {
  //   final header = <String, String>{
  //     'Content-Type': 'application/json; charset=UTF-8',
  //     'Authorization': 'Bearer $token',
  //   };
  //   final body = jsonEncode({'account': prescription.account});
  //   try {
  //     final response = await http.delete(
  //       Uri.parse(_getUrl(
  //           'cpoe/prescription/get-prescription-${prescription.presNum}/delete-medicine/${drugId}')),
  //       headers: header,
  //       body: body,
  //     );
  //     if (response.statusCode == 204) {
  //       fetchPrescriptions(patientID, token);
  //     } else {
  //       print('Failed to delete medicine ${jsonDecode(response.body)}');
  //     }
  //   } on Exception catch (e) {
  //     print('Failed to delete medicine. Error: $e');
  //   }
  // }
}
