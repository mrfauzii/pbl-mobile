import 'package:client/models/department_model.dart';
import 'package:client/models/employee_model.dart';
import 'package:client/models/position_model.dart';
import 'package:client/services/department_service.dart';
import 'package:client/services/employee_service.dart';
import 'package:client/services/position_service.dart';
import 'package:client/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditAdminEmployeeScreen extends StatefulWidget {
  final EmployeeModel employee;
  const EditAdminEmployeeScreen({super.key, required this.employee});

  @override
  State<EditAdminEmployeeScreen> createState() =>
      _EditAdminEmployeeScreenState();
}

class _EditAdminEmployeeScreenState extends State<EditAdminEmployeeScreen> {
  String? _status;
  int? _positionId;
  int? _departmentId;

  List<PositionModel> _positions = [];
  List<DepartmentModel> _departments = [];

  bool _isLoading = false;
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _status = widget.employee.employmentStatus.isNotEmpty
        ? widget.employee.employmentStatus
        : null;
    _positionId = widget.employee.positionId;
    _departmentId = widget.employee.departmentId;

    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoadingData = true);

    try {
      final positionsResponse = await PositionService.instance.getPositions();
      final departmentsResponse = await DepartmentService.instance
          .getDepartments();

      if (positionsResponse.success && positionsResponse.data != null) {
        _positions = positionsResponse.data!;
      }

      if (departmentsResponse.success && departmentsResponse.data != null) {
        _departments = departmentsResponse.data!;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingData = false);
      }
    }
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);

    try {
      final data = <String, dynamic>{};

      if (_status != null) data['employment_status'] = _status;
      if (_positionId != null) data['position_id'] = _positionId;
      if (_departmentId != null) data['department_id'] = _departmentId;

      final response = await EmployeeService.instance.updateManagement(
        widget.employee.id,
        data,
      );

      if (mounted) {
        if (response.success) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Berhasil diperbarui!')));
          context.pop();
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(response.message)));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Status, Posisi & Departemen'),
        backgroundColor: const Color.fromRGBO(29, 97, 231, 1),
        foregroundColor: Colors.white,
      ),
      body: _isLoadingData
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Status Karyawan
                  DropdownButtonFormField<String>(
                    value: _status,
                    decoration: _decoration('Status Karyawan'),
                    items: ['aktif', 'cuti', 'resign', 'phk']
                        .map(
                          (s) => DropdownMenuItem(
                            value: s,
                            child: Text(s.capitalize()),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => _status = val),
                  ),
                  const SizedBox(height: 20),

                  // Posisi
                  DropdownButtonFormField<int>(
                    value: _positionId,
                    decoration: _decoration('Posisi'),
                    items: [
                      const DropdownMenuItem<int>(
                        value: null,
                        child: Text('- Pilih Posisi -'),
                      ),
                      ..._positions.map(
                        (p) => DropdownMenuItem<int>(
                          value: p.id,
                          child: Text(p.name),
                        ),
                      ),
                    ],
                    onChanged: (val) => setState(() => _positionId = val),
                  ),
                  const SizedBox(height: 20),

                  // Departemen
                  DropdownButtonFormField<int>(
                    value: _departmentId,
                    decoration: _decoration('Departemen'),
                    items: [
                      const DropdownMenuItem<int>(
                        value: null,
                        child: Text('- Pilih Departemen -'),
                      ),
                      ..._departments.map(
                        (d) => DropdownMenuItem<int>(
                          value: d.id,
                          child: Text(d.name),
                        ),
                      ),
                    ],
                    onChanged: (val) => setState(() => _departmentId = val),
                  ),

                  const SizedBox(height: 40),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : CustomButton(
                          backgroundColor: const Color.fromRGBO(29, 97, 231, 1),
                          onPressed: _save,
                          child: const Text(
                            'Simpan Perubahan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                ],
              ),
            ),
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color.fromRGBO(29, 97, 231, 1),
          width: 2,
        ),
      ),
    );
  }
}

// Extension untuk capitalize
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
