import 'package:client/models/position_model.dart';
import 'package:client/services/position_service.dart';
import 'package:client/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class PositionCrudScreen extends StatefulWidget {
  const PositionCrudScreen({super.key});

  @override
  State<PositionCrudScreen> createState() => _PositionCrudScreenState();
}

class _PositionCrudScreenState extends State<PositionCrudScreen> {
  List<PositionModel> _positions = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPositions();
  }

  Future<void> _loadPositions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await PositionService.instance.getPositions();

      if (response.success && response.data != null) {
        setState(() {
          _positions = response.data!;
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

  void _showForm([PositionModel? pos]) {
    final isEdit = pos != null;
    final nameCtrl = TextEditingController(text: isEdit ? pos.name : '');
    final rateRegulerCtrl = TextEditingController(
      text: isEdit ? pos.rateReguler.toString() : '',
    );
    final rateOvertimeCtrl = TextEditingController(
      text: isEdit ? pos.rateOvertime.toString() : '',
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? 'Edit Posisi' : 'Tambah Posisi'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: nameCtrl,
                  label: "Nama Posisi",
                  hintText: "Contoh: Manager",
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: rateRegulerCtrl,
                  label: "Rate Regular",
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  hintText: "50000",
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: rateOvertimeCtrl,
                  label: "Rate Overtime",
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  hintText: "75000",
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
                'rate_reguler': double.tryParse(rateRegulerCtrl.text) ?? 0.0,
                'rate_overtime': double.tryParse(rateOvertimeCtrl.text) ?? 0.0,
              };

              try {
                if (isEdit) {
                  await PositionService.instance.updatePosition(pos!.id, data);
                } else {
                  await PositionService.instance.createPosition(data);
                }

                if (mounted) {
                  Navigator.pop(context);
                  _loadPositions();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isEdit ? 'Posisi diperbarui' : 'Posisi ditambahkan',
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

  Future<void> _deletePosition(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Yakin ingin menghapus posisi ini?'),
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
        await PositionService.instance.deletePosition(id);
        _loadPositions();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Posisi berhasil dihapus')),
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
        title: const Text('Kelola Posisi'),
        backgroundColor: const Color.fromRGBO(29, 97, 231, 1),
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(onRefresh: _loadPositions, child: _buildBody()),
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

    if (_positions.isEmpty) {
      return const Center(child: Text('Belum ada posisi'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _positions.length,
      itemBuilder: (context, i) {
        final p = _positions[i];
        return Card(
          child: ListTile(
            title: Text(
              p.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Rate Regular: Rp ${p.rateReguler.toStringAsFixed(0)}\n'
              'Rate Overtime: Rp ${p.rateOvertime.toStringAsFixed(0)}',
            ),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showForm(p),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deletePosition(p.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
