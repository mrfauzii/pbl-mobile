class LeaveType {
  final int id;
  final String name;
  final String content;

  LeaveType({
    required this.id,
    required this.name,
    required this.content,
  });

  factory LeaveType.fromJson(Map<String, dynamic> json) {
    return LeaveType(
      id: json['id'],
      name: json['name'],
      content: json['content'] ?? '',
    );
  }
}
