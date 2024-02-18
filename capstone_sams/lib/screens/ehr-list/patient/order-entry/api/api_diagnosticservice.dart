import 'package:capstone_sams/constants/Env.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static final String apiUrl = '${Env.prefix}/diagnostics';
  static Future<int?> getLatestRecordId() async {
    final response = await http.get(
      Uri.parse('$apiUrl/get_latest_record_id/'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['latest_record_id'] as int?;
    } else {
      return null;
    }
  }

  static Future<bool> deleteRecordById(int recordId) async {
    final url = '$apiUrl/delete_diagnostic_record/$recordId/';

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  // Function to delete the latest record
  static Future<void> deleteLatestRecord() async {
    final latestRecordId = await getLatestRecordId();
    if (latestRecordId != null) {
      final isDeleted = await deleteRecordById(latestRecordId);
      if (isDeleted) {
        print('Latest record with ID $latestRecordId has been deleted.');
      } else {
        print('Failed to delete the latest record.');
      }
    } else {
      print('Unable to retrieve the latest record ID.');
    }
  }

  static Future<bool> updateDisease(
      BuildContext context, String newDisease) async {
    try {
      final latestRecordId = await getLatestRecordId();
      if (latestRecordId != null) {
        if (newDisease.isNotEmpty) {
          newDisease = newDisease[0].toUpperCase() + newDisease.substring(1);
        }

        final response = await http.post(
          Uri.parse('$apiUrl/update_disease/$latestRecordId/'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'new_disease': newDisease}),
        );

        if (response.statusCode == 200) {
          print('Prognosis updated successfully.');
          return true;
        } else {
          print('Failed to update prognosis.');
          return false;
        }
      } else {
        print('Unable to retrieve the latest record ID.');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
