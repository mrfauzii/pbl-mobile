import 'package:client/models/izin_manager_model.dart';
import 'package:client/utils/constant.dart';
import 'package:client/services/base_service.dart';

class IzinService extends BaseService<IzinModel> {
  // ---------------- DASHBOARD ----------------
  Future<Map<String, int>> loadDashboard() async {
    final res = await dio.get("${Constant.apiUrl}/izin-dashboard");

    final data = res.data["data"] ?? {};

    return {
      "approvedOrRejected": data["total_letters_approved_or_rejected"] ?? 0,
      "pending": data["total_letters_pending"] ?? 0,
    };
  }

  // ---------------- LIST IZIN ----------------
  Future<List<IzinModel>> loadIzinList() async {
    final res = await dio.get("${Constant.apiUrl}/izin-list");

    return parseData(res.data, "data", (json) => IzinModel.fromJson(json));
  }

  // ---------------- IZIN DETAIL ----------------
  Future<IzinModel?> loadIzinDetail(int id) async {
    final res = await dio.get("${Constant.apiUrl}/izin-detail/$id");

    if (res.data["data"] == null) return null;

    return IzinModel.fromJson(res.data["data"]);
  }

  // ---------------- UPDATE STATUS ----------------
  // ✅ UPDATED: Tidak perlu kirim approved_by (diambil dari token di backend)
  Future<bool> updateStatus(int id, int newStatus, String notes) async {
    final res = await dio.post(
      "${Constant.apiUrl}/izin-update/$id",
      data: {
        "status": newStatus,
        "notes": notes,
        // ❌ REMOVED: "approved_by" - akan diambil dari auth:sanctum di backend
      },
    );

    return res.data["success"] == true;
  }
}