import 'dart:developer';
import 'package:client/models/employee_model.dart';
import 'package:client/services/base_service.dart';
import 'package:client/utils/api_wrapper.dart';
import 'package:dio/dio.dart';

class EmployeeService extends BaseService<EmployeeModel> {
  EmployeeService._();
  static final EmployeeService instance = EmployeeService._();

  /// Get all employees
  Future<ApiResponse<List<EmployeeModel>>> getEmployees() async {
    try {
      final response = await dio.get("/employees");

      return ApiResponse<List<EmployeeModel>>.fromJson(response.data, (
        jsonData,
      ) {
        return parseData(jsonData, "employees", EmployeeModel.fromJson);
      });
    } catch (e, s) {
      log("Error: Get Employees Failed", error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Get employee by ID
  Future<ApiResponse<EmployeeModel>> getEmployeeById(int id) async {
    try {
      final response = await dio.get("/employees/$id");

      return ApiResponse<EmployeeModel>.fromJson(response.data, (jsonData) {
        final data = jsonData as Map<String, dynamic>;
        return EmployeeModel.fromJson(data['employee']);
      });
    } catch (e, s) {
      log("Error: Get Employee By ID Failed", error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Update employee profile (by employee themselves)
  /// Only updates: first_name, last_name, gender, address
  Future<ApiResponse<EmployeeModel>> updateProfile(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dio.patch(
        "/employee/profile/$id",
        data: data,
        options: Options(headers: {"accept": "application/json"}),
      );

      return ApiResponse<EmployeeModel>.fromJson(response.data, (jsonData) {
        final responseData = jsonData as Map<String, dynamic>;
        return EmployeeModel.fromJson(responseData['employee']);
      });
    } on DioException catch (e, s) {
      log("Error: Update Profile Failed", error: e, stackTrace: s);

      if (e.response?.statusCode == 422) {
        throw Exception('Validasi gagal: ${e.response?.data['errors']}');
      }

      throw Exception(
        e.response?.data['message'] ?? 'Gagal memperbarui profil',
      );
    }
  }

  /// Update employee management data (by admin)
  /// Only updates: employment_status, position_id, department_id
  Future<ApiResponse<EmployeeModel>> updateManagement(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dio.patch(
        "/employee/management/$id",
        data: data,
        options: Options(headers: {"accept": "application/json"}),
      );

      return ApiResponse<EmployeeModel>.fromJson(response.data, (jsonData) {
        final responseData = jsonData as Map<String, dynamic>;
        return EmployeeModel.fromJson(responseData['employee']);
      });
    } on DioException catch (e, s) {
      log("Error: Update Management Failed", error: e, stackTrace: s);

      if (e.response?.statusCode == 422) {
        throw Exception('Validasi gagal: ${e.response?.data['errors']}');
      }

      throw Exception(
        e.response?.data['message'] ?? 'Gagal memperbarui data manajemen',
      );
    }
  }
}
