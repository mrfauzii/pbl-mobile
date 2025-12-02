import 'package:client/models/department_model.dart';
import 'package:client/services/department_service.dart';
import 'package:client/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class DepartmentCrudScreen extends StatefulWidget {
  const DepartmentCrudScreen({super.key});

  @override
  State<DepartmentCrudScreen> createState() => _DepartmentCrudScreenState();
}

class _DepartmentCrudScreenState extends State<DepartmentCrudScreen> {
  List<DepartmentModel> _departments = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await DepartmentService.instance.getDepartments();

      if (response.success && response.data != null) {
        setState(() {
          _departments = response.data!;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showForm([DepartmentModel? dept]) {
    final isEdit = dept != null;
    final nameCtrl = TextEditingController(text: isEdit ? dept.name : '');
    final latCtrl = TextEditingController(
      text: isEdit ? dept.latitude.toString() : '',
    );
    final lngCtrl = TextEditingController(
      text: isEdit ? dept.longitude.toString() : '',
    );
    final radiusCtrl = TextEditingController(
      text: isEdit ? dept.radiusMeters.toString() : '',
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? 'Edit Departemen' : 'Tambah Departemen'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: nameCtrl,
                  label: "Nama Departemen",
                  hintText: "Contoh: Marketing",
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: latCtrl,
                  label: "Latitude",
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  hintText: "Contoh: -6.200000",
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: lngCtrl,
                  label: "Longitude",
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  hintText: "Contoh: 106.816666",
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: radiusCtrl,
                  label: "Radius (meter)",
                  keyboardType: TextInputType.number,
                  hintText: "100",
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(29, 97, 231, 1),
            ),
            onPressed: () async {
              final data = {
                'name': nameCtrl.text.trim(),
                'latitude': double.tryParse(latCtrl.text) ?? 0.0,
                'longitude': double.tryParse(lngCtrl.text) ?? 0.0,
                'radius_meters': int.tryParse(radiusCtrl.text) ?? 0,
              };

              try {
                if (isEdit) {
                  await DepartmentService.instance.updateDepartment(
                    dept!.id,
                    data,
                  );
                } else {
                  await DepartmentService.instance.createDepartment(data);
                }

                if (mounted) {
                  Navigator.pop(context);
                  _loadDepartments();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isEdit
                            ? 'Departemen diperbarui'
                            : 'Departemen ditambahkan',
                      ),
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
              }
            },
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDepartment(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Yakin ingin menghapus departemen ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await DepartmentService.instance.deleteDepartment(id);
        _loadDepartments();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Departemen berhasil dihapus')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Gagal menghapus: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Departemen'),
        backgroundColor: const Color.fromRGBO(29, 97, 231, 1),
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(onRefresh: _loadDepartments, child: _buildBody()),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(29, 97, 231, 1),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showForm(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text('Error: $_errorMessage'));
    }

    if (_departments.isEmpty) {
      return const Center(child: Text('Belum ada departemen'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _departments.length,
      itemBuilder: (context, i) {
        final d = _departments[i];
        return Card(
          child: ListTile(
            title: Text(
              d.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Lat: ${d.latitude.toStringAsFixed(6)} | '
              'Lng: ${d.longitude.toStringAsFixed(6)}\n'
              'Radius: ${d.radiusMeters} m',
            ),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showForm(d),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteDepartment(d.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
