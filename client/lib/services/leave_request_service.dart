import 'package:client/utils/api_wrapper.dart';
import 'package:client/models/leave_type_model.dart';
import 'package:client/models/leave_request_model.dart';
import 'package:client/services/base_service.dart';

class LeaveRequestService extends BaseService { // ✅ Extend BaseService
  LeaveRequestService._();
  static final LeaveRequestService instance = LeaveRequestService._();

  /// GET employee profile (auto-filled from token)
  Future<ApiResponse<Map<String, dynamic>>> getEmployeeProfile() async {
    try {
      final res = await dio.get('/get-profile'); // ✅ Now can access dio

      if (res.statusCode == 200 && res.data['success'] == true) {
        return ApiResponse<Map<String, dynamic>>(
          message: "Berhasil memuat profil",
          success: true,
          data: res.data['data'],
        );
      }

      return ApiResponse<Map<String, dynamic>>(
        message: res.data['message'] ?? "Gagal memuat profil",
        success: false,
        data: null,
      );
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        message: e.toString(),
        success: false,
        data: null,
      );
    }
  }

  /// GET list jenis izin
  Future<ApiResponse<List<LeaveType>>> getLeaveTypes() async {
    try {
      final res = await dio.get('/letter-formats');

      if (res.statusCode == 200 && res.data['success'] == true) {
        List<LeaveType> list = (res.data['data'] as List)
            .map((e) => LeaveType.fromJson(e))
            .toList();

        return ApiResponse<List<LeaveType>>(
          message: "Berhasil memuat data",
          success: true,
          data: list,
        );
      }

      return ApiResponse<List<LeaveType>>(
        message: res.data['message'] ?? "Gagal memuat data",
        success: false,
        data: null,
      );
    } catch (e) {
      return ApiResponse<List<LeaveType>>(
        message: e.toString(),
        success: false,
        data: null,
      );
    }
  }

  /// POST pengajuan izin (employee_id from token)
  Future<ApiResponse<String>> submitLeave(LeaveRequestPayload payload) async {
    try {
      final res = await dio.post('/letters', data: payload.toJson());

      if (res.statusCode == 201 && res.data['success'] == true) {
        return ApiResponse<String>(
          message: res.data['message'] ?? "Berhasil mengajukan izin",
          success: true,
          data: null,
        );
      }

      return ApiResponse<String>(
        message: res.data['message'] ?? "Gagal mengajukan izin",
        success: false,
        data: null,
      );
    } catch (e) {
      return ApiResponse<String>(
        message: e.toString(),
        success: false,
        data: null,
      );
    }
  }
}