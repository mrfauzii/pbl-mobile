import 'package:client/models/employee_model.dart';
import 'package:client/services/employee_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmployeeListScreen extends StatefulWidget {
  final bool isKaryawanMode;
  const EmployeeListScreen({super.key, required this.isKaryawanMode});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  List<EmployeeModel> _employees = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await EmployeeService.instance.getEmployees();

      print("Response success: ${response.success}"); // Debug
      print("Response message: ${response.message}"); // Debug
      print("Response data: ${response.data}"); // Debug

      if (response.success && response.data != null) {
        setState(() {
          _employees = response.data!;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response.message.isEmpty
              ? 'Gagal memuat data karyawan'
              : response.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading employees: $e"); // Debug
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    await _loadEmployees();
  }

  void _backToRoleSelection() {
    context.go('/role-selection');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isKaryawanMode
              ? 'Daftar Karyawan'
              : 'Pilih Karyawan untuk Edit',
        ),
        backgroundColor: const Color.fromRGBO(29, 97, 231, 1),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: _backToRoleSelection,
        ),
        actions: widget.isKaryawanMode
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: _backToRoleSelection,
                  tooltip: 'Kembali ke Menu Utama',
                ),
              ],
      ),
      body: RefreshIndicator(onRefresh: _refresh, child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error: $_errorMessage',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refresh,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(29, 97, 231, 1),
              ),
              child: const Text(
                'Coba Lagi',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    if (_employees.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.people_outline, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Belum ada data karyawan',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _employees.length,
      itemBuilder: (context, i) {
        final emp = _employees[i];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color.fromRGBO(29, 97, 231, 1),
              radius: 25,
              child: Text(
                emp.fullName.isNotEmpty ? emp.fullName[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              emp.fullName,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(emp.position?.name ?? 'Belum ada posisi'),
                Text(
                  emp.department?.name ?? 'Belum ada departemen',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () async {
              final result = await context.push<bool>(
                '/employee-detail/${emp.id}',
                extra: {
                  'employee': emp,
                  'isKaryawanMode': widget.isKaryawanMode,
                },
              );

              // JIKA ADA PERUBAHAN DARI DETAIL SCREEN, RELOAD LIST
              if (result == true) {
                _loadEmployees();
              }
            },
          ),
        );
      },
    );
  }
}
