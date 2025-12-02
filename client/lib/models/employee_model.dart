import 'position_model.dart';
import 'department_model.dart';
import 'user_model.dart';

class EmployeeModel {
  final int id;
  final String firstName;
  final String lastName;
  final String gender;
  final String address;
  final String employmentStatus;
  final int? positionId;
  final int? departmentId;
  final int userId;
  final PositionModel? position;
  final DepartmentModel? department;
  final UserModel? user;
  final String createdAt;
  final String updatedAt;

  EmployeeModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.address,
    required this.employmentStatus,
    this.positionId,
    this.departmentId,
    required this.userId,
    this.position,
    this.department,
    this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      gender: json['gender'] ?? '',
      address: json['address'] ?? '',
      employmentStatus: json['employment_status'] ?? json['employement_status'] ?? 'aktif',
      positionId: json['position_id'] is int
          ? json['position_id']
          : int.tryParse(json['position_id'].toString()),
      departmentId: json['department_id'] ?? json['departement_id'] is int
          ? (json['department_id'] ?? json['departement_id'])
          : int.tryParse((json['department_id'] ?? json['departement_id']).toString()),
      userId: json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id'].toString()) ?? 0,
      position: json['position'] != null
          ? PositionModel.fromJson(json['position'])
          : null,
      department: json['department'] != null
          ? DepartmentModel.fromJson(json['department'])
          : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'gender': gender,
    'address': address,
    'employment_status': employmentStatus,
    'position_id': positionId,
    'department_id': departmentId,
    'user_id': userId,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };

  // For profile update (employee only)
  Map<String, dynamic> toProfileJson() => {
    'first_name': firstName,
    'last_name': lastName,
    'gender': gender,
    'address': address,
  };

  // For management update (admin only)
  Map<String, dynamic> toManagementJson() => {
    'employment_status': employmentStatus,
    'position_id': positionId,
    'department_id': departmentId,
  };
}