import 'package:client/models/employee_model.dart';
import 'package:client/services/employee_service.dart';
import 'package:client/widgets/custom_button.dart';
import 'package:client/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditPersonalScreen extends StatefulWidget {
  final EmployeeModel employee;
  const EditPersonalScreen({super.key, required this.employee});

  @override
  State<EditPersonalScreen> createState() => _EditPersonalScreenState();
}

class _EditPersonalScreenState extends State<EditPersonalScreen> {
  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _addressCtrl;
  String? _gender;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController(text: widget.employee.firstName);
    _lastNameCtrl = TextEditingController(text: widget.employee.lastName);
    _addressCtrl = TextEditingController(text: widget.employee.address);
    _gender = widget.employee.gender;
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);

    try {
      final data = <String, dynamic>{};

      if (_gender != null) data['gender'] = _gender;
      if (_firstNameCtrl.text.trim().isNotEmpty)
        data['first_name'] = _firstNameCtrl.text.trim();
      if (_lastNameCtrl.text.trim().isNotEmpty)
        data['last_name'] = _lastNameCtrl.text.trim();
      if (_addressCtrl.text.trim().isNotEmpty)
        data['address'] = _addressCtrl.text.trim();

      data['_method'] = 'PATCH'; // Method spoofing

      final response = await EmployeeService.instance.updateProfile(
        widget.employee.id,
        data,
      );

      if (mounted) {
        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data pribadi berhasil diperbarui')),
          );

          // RETURN TRUE UNTUK SIGNAL BERHASIL UPDATE
          context.pop(true);
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
        title: const Text('Edit Data Pribadi'),
        backgroundColor: const Color.fromRGBO(29, 97, 231, 1),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomTextField(
              controller: _firstNameCtrl,
              label: "Nama Depan",
              hintText: "Masukkan nama depan",
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _lastNameCtrl,
              label: "Nama Belakang",
              hintText: "Masukkan nama belakang",
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Jenis Kelamin",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(29, 97, 231, 1),
                        width: 2,
                      ),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'L', child: Text('Laki-laki')),
                    DropdownMenuItem(value: 'P', child: Text('Perempuan')),
                  ],
                  onChanged: (val) => setState(() => _gender = val),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _addressCtrl,
              label: "Alamat",
              hintText: "Masukkan alamat lengkap",
              maxLines: 3,
            ),
            const SizedBox(height: 30),
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
}
