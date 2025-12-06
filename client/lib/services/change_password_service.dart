import 'dart:developer';

import 'package:client/services/base_service.dart';
import 'package:client/utils/api_wrapper.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChangePasswordService extends BaseService {
  ChangePasswordService._();

  static ChangePasswordService instance = ChangePasswordService._();
  final storage = FlutterSecureStorage();

  Future<ApiResponse> getToken(String email) async {
    final response = await dio.post(
      "/send-token",
      data: {"email": email},
      options: Options(validateStatus: (_) => true),
    );
    final json = response.data;

    if (response.statusCode != 200) {
      log("Error: Change password failed: ${json['message']}");
      return ApiResponse(
        message: json["message"],
        success: false,
        data: json["data"],
        error: json["error"],
      );
    }
    await storage.write(key: "user_id_token", value: json["data"].toString());

    return ApiResponse(
      message: json["message"],
      success: true,
      data: json["data"],
      error: json["error"],
    );
  }

  Future<ApiResponse> checkToken(String token) async {
    int? userId = await _getUserId();
    final response = await dio.post(
      "/check-token",
      data: {"user_id": userId, "token": token},
      options: Options(validateStatus: (_) => true),
    );

    final json = response.data;

    if (response.statusCode != 200) {
      log("Error: Change token failed: ${json['message']}");
      return ApiResponse(message: json["message"], success: false);
    }
    return ApiResponse(message: json["message"], success: true);
  }

  Future<ApiResponse> changePassword(String newPassword) async {
    int? userId = await _getUserId();
    final response = await dio.post(
      "/change-password",
      data: {"user_id": userId, "new_password": newPassword},
    );

    final json = response.data;

    if (response.statusCode != 200) {
      log("Error: Change password failed: ${json['message']}");
      return ApiResponse(message: json["message"], success: false);
    }
    return ApiResponse(message: json["message"], success: true);
  }

  Future<int?> _getUserId() async {
    final userId = await storage.read(key: "user_id_token");
    return int.tryParse(userId ?? "");
  }
}
