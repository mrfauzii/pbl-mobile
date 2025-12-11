class IzinModel {
  final int id;
  final int statusCode;
  final String statusText;

  // LIST DATA
  final String date;
  final String fullName;
  final String position;
  final String department;

  // DETAIL DATA
  final String requestDate;
  final String startDate;
  final String endDate;
  final String reason;
  final String letterName;
  final String notes;

  // ✅ NEW: Approved fields
  final String? approvedAt;
  final String? approvedBy;

  IzinModel({
    required this.id,
    required this.statusCode,
    required this.statusText,
    required this.date,
    required this.fullName,
    required this.position,
    required this.department,
    required this.requestDate,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.letterName,
    required this.notes,
    this.approvedAt, // ✅ NEW
    this.approvedBy, // ✅ NEW
  });

  factory IzinModel.fromJson(Map<String, dynamic> json) {
    final int? rawStatus = json["status"] as int?;
    String statusText;
    switch (rawStatus) {
      case 0:
        statusText = "Diproses";
        break;
      case 1:
        statusText = "Diterima";
        break;
      case 2:
        statusText = "Ditolak";
        break;
      default:
        statusText = "Unknown";
    }

    return IzinModel(
      id: json["id"] ?? 0,
      statusCode: rawStatus ?? -1,
      statusText: statusText,

      // LIST
      date: json["request_date"]?.toString() ?? json["date"]?.toString() ?? "",
      fullName: json["full_name"]?.toString() ?? "",
      position: json["position"]?.toString() ?? "",
      department: json["department_name"]?.toString() ?? "",

      // DETAIL DATA
      requestDate: json["request_date"]?.toString() ?? "",
      startDate: json["effective_start_date"]?.toString() ?? "",
      endDate: json["effective_end_date"]?.toString() ?? "",
      reason: json["reason"]?.toString() ?? "",
      letterName: json["letter_name"]?.toString() ?? "",
      notes: json["notes"]?.toString() ?? "",

      // ✅ NEW: Approved fields
      approvedAt: json["approved_at"]?.toString(),
      approvedBy: json["approved_by_name"]?.toString(), // From backend join
    );
  }
}