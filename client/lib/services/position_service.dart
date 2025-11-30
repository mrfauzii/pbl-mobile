import 'dart:developer';
import 'package:client/models/position_model.dart';
import 'package:client/services/base_service.dart';
import 'package:client/utils/api_wrapper.dart';
import 'package:dio/dio.dart';

class PositionService extends BaseService<PositionModel> {
  PositionService._();
  static final PositionService instance = PositionService._();

  /// Get all positions
  Future<ApiResponse<List<PositionModel>>> getPositions() async {
    try {
      final response = await dio.get("/positions");

      return ApiResponse<List<PositionModel>>.fromJson(response.data, (
        jsonData,
      ) {
        return parseData(jsonData, "positions", PositionModel.fromJson);
      });
    } catch (e, s) {
      log("Error: Get Positions Failed", error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Get position by ID
  Future<ApiResponse<PositionModel>> getPositionById(int id) async {
    try {
      final response = await dio.get("/positions/$id");

      return ApiResponse<PositionModel>.fromJson(response.data, (jsonData) {
        final data = jsonData as Map<String, dynamic>;
        return PositionModel.fromJson(data['position']);
      });
    } catch (e, s) {
      log("Error: Get Position By ID Failed", error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Create new position (admin only)
  Future<ApiResponse<PositionModel>> createPosition(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dio.post(
        "/positions",
        data: data,
        options: Options(headers: {"accept": "application/json"}),
      );

      return ApiResponse<PositionModel>.fromJson(response.data, (jsonData) {
        final responseData = jsonData as Map<String, dynamic>;
        return PositionModel.fromJson(responseData['position']);
      });
    } on DioException catch (e, s) {
      log("Error: Create Position Failed", error: e, stackTrace: s);

      if (e.response?.statusCode == 422) {
        throw Exception('Validasi gagal: ${e.response?.data['errors']}');
      }

      throw Exception(e.response?.data['message'] ?? 'Gagal membuat posisi');
    }
  }

  /// Update position (admin only)
  Future<ApiResponse<PositionModel>> updatePosition(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dio.patch(
        "/positions/$id",
        data: data,
        options: Options(headers: {"accept": "application/json"}),
      );

      return ApiResponse<PositionModel>.fromJson(response.data, (jsonData) {
        final responseData = jsonData as Map<String, dynamic>;
        return PositionModel.fromJson(responseData['position']);
      });
    } on DioException catch (e, s) {
      log("Error: Update Position Failed", error: e, stackTrace: s);

      if (e.response?.statusCode == 422) {
        throw Exception('Validasi gagal: ${e.response?.data['errors']}');
      }

      throw Exception(
        e.response?.data['message'] ?? 'Gagal memperbarui posisi',
      );
    }
  }

  /// Delete position (admin only)
  Future<ApiResponse<void>> deletePosition(int id) async {
    try {
      final response = await dio.delete(
        "/positions/$id",
        options: Options(headers: {"accept": "application/json"}),
      );

      return ApiResponse<void>.fromJson(response.data, (jsonData) => null);
    } on DioException catch (e, s) {
      log("Error: Delete Position Failed", error: e, stackTrace: s);

      throw Exception(e.response?.data['message'] ?? 'Gagal menghapus posisi');
    }
  }
}
