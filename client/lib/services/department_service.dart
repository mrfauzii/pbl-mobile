import 'dart:developer';
import 'package:client/models/department_model.dart';
import 'package:client/services/base_service.dart';
import 'package:client/utils/api_wrapper.dart';
import 'package:dio/dio.dart';

class DepartmentService extends BaseService<DepartmentModel> {
  DepartmentService._();
  static final DepartmentService instance = DepartmentService._();

  /// Get all departments
  Future<ApiResponse<List<DepartmentModel>>> getDepartments() async {
    try {
      final response = await dio.get("/departments");

      return ApiResponse<List<DepartmentModel>>.fromJson(response.data, (
        jsonData,
      ) {
        return parseData(jsonData, "departments", DepartmentModel.fromJson);
      });
    } catch (e, s) {
      log("Error: Get Departments Failed", error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Get department by ID
  Future<ApiResponse<DepartmentModel>> getDepartmentById(int id) async {
    try {
      final response = await dio.get("/departments/$id");

      return ApiResponse<DepartmentModel>.fromJson(response.data, (jsonData) {
        final data = jsonData as Map<String, dynamic>;
        return DepartmentModel.fromJson(data['department']);
      });
    } catch (e, s) {
      log("Error: Get Department By ID Failed", error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Create new department (admin only)
  Future<ApiResponse<DepartmentModel>> createDepartment(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dio.post(
        "/departments",
        data: data,
        options: Options(headers: {"accept": "application/json"}),
      );

      return ApiResponse<DepartmentModel>.fromJson(response.data, (jsonData) {
        final responseData = jsonData as Map<String, dynamic>;
        return DepartmentModel.fromJson(responseData['department']);
      });
    } on DioException catch (e, s) {
      log("Error: Create Department Failed", error: e, stackTrace: s);

      if (e.response?.statusCode == 422) {
        throw Exception('Validasi gagal: ${e.response?.data['errors']}');
      }

      throw Exception(
        e.response?.data['message'] ?? 'Gagal membuat departemen',
      );
    }
  }

  /// Update department (admin only)
  Future<ApiResponse<DepartmentModel>> updateDepartment(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dio.patch(
        "/departments/$id",
        data: data,
        options: Options(headers: {"accept": "application/json"}),
      );

      return ApiResponse<DepartmentModel>.fromJson(response.data, (jsonData) {
        final responseData = jsonData as Map<String, dynamic>;
        return DepartmentModel.fromJson(responseData['department']);
      });
    } on DioException catch (e, s) {
      log("Error: Update Department Failed", error: e, stackTrace: s);

      if (e.response?.statusCode == 422) {
        throw Exception('Validasi gagal: ${e.response?.data['errors']}');
      }

      throw Exception(
        e.response?.data['message'] ?? 'Gagal memperbarui departemen',
      );
    }
  }

  /// Delete department (admin only)
  Future<ApiResponse<void>> deleteDepartment(int id) async {
    try {
      final response = await dio.delete(
        "/departments/$id",
        options: Options(headers: {"accept": "application/json"}),
      );

      return ApiResponse<void>.fromJson(response.data, (jsonData) => null);
    } on DioException catch (e, s) {
      log("Error: Delete Department Failed", error: e, stackTrace: s);

      throw Exception(
        e.response?.data['message'] ?? 'Gagal menghapus departemen',
      );
    }
  }
}
