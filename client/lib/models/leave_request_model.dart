class LeaveRequestPayload {
  final int employeeId;
  final int letterFormatId;
  final String title;
  final String startDate;
  final String endDate;
  final String notes;
  final Map<String, dynamic> employee;

  LeaveRequestPayload({
    required this.employeeId,
    required this.letterFormatId,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.notes,
    required this.employee,
  });

  Map<String, dynamic> toJson() {
    return {
      'employee_id': employeeId,
      'letter_format_id': letterFormatId,
      'title': title,
      'effective_start_date': startDate,
      'effective_end_date': endDate,
      'notes': notes,
      'employee_data': employee,
    };
  }
}