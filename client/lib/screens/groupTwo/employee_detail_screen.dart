import 'package:client/models/employee_model.dart';
import 'package:client/services/employee_service.dart';
import 'package:client/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final EmployeeModel initialEmployee;
  final bool isKaryawanMode;

  const EmployeeDetailScreen({
    super.key,
    required this.initialEmployee,
    required this.isKaryawanMode,
  });

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  late EmployeeModel _employee;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _employee = widget.initialEmployee;
  }

  // RELOAD DATA EMPLOYEE DARI API
  Future<void> _refreshEmployee() async {
    setState(() => _isLoading = true);

    try {
      final response = await EmployeeService.instance.getEmployeeById(
        _employee.id,
      );

      if (response.success && response.data != null) {
        setState(() {
          _employee = response.data!;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(response.message)));
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_employee.fullName),
        backgroundColor: const Color.fromRGBO(29, 97, 231, 1),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // POP DENGAN TRUE JIKA ADA PERUBAHAN
            context.pop(true);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshEmployee,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Center(
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(29, 97, 231, 1),
                        radius: 50,
                        child: Text(
                          _employee.fullName.isNotEmpty
                              ? _employee.fullName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Info Cards
                    _buildInfoCard('Nama Depan', _employee.firstName),
                    _buildInfoCard('Nama Belakang', _employee.lastName),
                    _buildInfoCard(
                      'Jenis Kelamin',
                      _employee.gender == 'L' ? 'Laki-laki' : 'Perempuan',
                    ),
                    _buildInfoCard('Alamat', _employee.address),
                    _buildInfoCard('Status', _employee.employmentStatus),
                    _buildInfoCard('Posisi', _employee.position?.name ?? '-'),
                    _buildInfoCard(
                      'Departemen',
                      _employee.department?.name ?? '-',
                    ),

                    const SizedBox(height: 30),

                    // Action Button
                    if (widget.isKaryawanMode)
                      CustomButton(
                        backgroundColor: const Color.fromRGBO(29, 97, 231, 1),
                        onPressed: () async {
                          final result = await context.push<bool>(
                            '/employee/edit-personal/${_employee.id}',
                            extra: _employee,
                          );

                          // JIKA BERHASIL UPDATE, REFRESH DATA
                          if (result == true) {
                            await _refreshEmployee();
                          }
                        },
                        child: const Text(
                          'Edit Data Pribadi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    else
                      CustomButton(
                        backgroundColor: const Color.fromRGBO(29, 97, 231, 1),
                        onPressed: () async {
                          final result = await context.push<bool>(
                            '/employee/edit-management/${_employee.id}',
                            extra: _employee,
                          );

                          // JIKA BERHASIL UPDATE, REFRESH DATA
                          if (result == true) {
                            await _refreshEmployee();
                          }
                        },
                        child: const Text(
                          'Edit Status, Posisi & Departemen',
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
            ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color.fromRGBO(108, 114, 120, 1),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            value.isEmpty ? '-' : value,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
