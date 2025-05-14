import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:japx/japx.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://test.myfliqapp.com/api/v1';

  static Future<Map<String, dynamic>> requestOTP(String phoneNumber) async {
    final url = Uri.parse(
        '$baseUrl/auth/registration-otp-codes/actions/phone/send-otp');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'data': {
          'type': 'registration_otp_codes',
          'attributes': {
            'phone': phoneNumber,
          }
        }
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to request OTP: ${response.body}');
    }
  }

  static verifyOTP(String phoneNumber, String otp) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final url = Uri.parse(
        'https://test.myfliqapp.com/api/v1/auth/registration-otp-codes/actions/phone/verify-otp');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "data": {
          "type": "registration-otp-codes",
          "attributes": {
            "phone": "${phoneNumber}",
            "otp": int.parse(otp),
            "device_meta": {
              "type": "Android",
              "device-name": "Redmi Note 11",
              "device-os-version": "13",
              "browser": null,
              "browser_version": null,
              "user-agent": null,
              "screen_resolution": null,
              "language": null
            },
          }
        }
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final jsonApiDocument = jsonDecode(response.body);

      final decodedJson = Japx.decode(jsonApiDocument);

      print(decodedJson["data"]["auth_status"]["access_token"]);

      return decodedJson;
    } else {
      throw Exception('Failed to verify OTP: ${response.body}');
    }
  }

  static Future getChatProfiles() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String accessToken = prefs.getString('access-token') ?? '';

      final response = await http.get(
        Uri.parse('$baseUrl/chat/chat-messages/queries/contact-users'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonApiDocument = json.decode(response.body);

        final normalizedJson = Japx.decode(jsonApiDocument);

        return normalizedJson["data"];
      } else {
        throw Exception(
            'Failed to load chat profiles: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching chat profiles: $e');
    }
  }
}
