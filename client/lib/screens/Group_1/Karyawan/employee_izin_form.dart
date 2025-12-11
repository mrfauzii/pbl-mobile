import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:client/models/leave_type_model.dart';
import 'package:client/models/leave_request_model.dart';
import 'package:client/services/leave_request_service.dart';
import 'package:client/utils/api_wrapper.dart';

class LeaveRequestFormScreen extends StatefulWidget {
  @override
  _LeaveRequestFormScreenState createState() => _LeaveRequestFormScreenState();
}

class _LeaveRequestFormScreenState extends State<LeaveRequestFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameC = TextEditingController();
  final TextEditingController positionC = TextEditingController();
  final TextEditingController deptC = TextEditingController();
  final TextEditingController reasonC = TextEditingController();

  LeaveType? _selectedType;
  DateTime? startDate;
  DateTime? endDate;

  late Future<ApiResponse<List<LeaveType>>> leaveTypesFuture;
  bool submitting = false;
  bool _loadingProfile = true;

  int? _employeeId;

  @override
  void initState() {
    super.initState();
    leaveTypesFuture = LeaveRequestService.instance.getLeaveTypes();
    _loadEmployeeProfile();
  }

  Future<void> _loadEmployeeProfile() async {
    try {
      final response = await LeaveRequestService.instance.getEmployeeProfile();

      if (response.success && response.data != null) {
        final profile = response.data!;
        final firstName = profile['first_name'] ?? '';
        final lastName = profile['last_name'] ?? '';
        final fullName = '$firstName $lastName'.trim();

        setState(() {
          _employeeId = profile['id'];
          nameC.text = fullName.isNotEmpty ? fullName : 'Nama tidak tersedia';
          positionC.text = profile['position']?['name'] ?? '';
          deptC.text = profile['department']?['name'] ?? '';
          _loadingProfile = false;
        });
      } else {
        setState(() => _loadingProfile = false);
        _snack("Gagal memuat profil: ${response.message}", error: true);
      }
    } catch (e) {
      setState(() => _loadingProfile = false);
      _snack("Error memuat profil: $e", error: true);
    }
  }

  Future<void> pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? startDate : endDate) ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
          if (endDate != null && endDate!.isBefore(startDate!)) {
            endDate = null;
          }
        } else {
          endDate = picked;
        }
      });
    }
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedType == null) return _snack("Pilih jenis izin");
    if (startDate == null || endDate == null) {
      return _snack("Isi tanggal mulai & selesai");
    }
    if (_employeeId == null) {
      return _snack("Employee ID tidak ditemukan", error: true);
    }

    setState(() => submitting = true);

    try {
      final payload = LeaveRequestPayload(
        employeeId: _employeeId!,
        letterFormatId: _selectedType!.id,
        title: "Pengajuan Izin ${nameC.text}",
        startDate: startDate!.toIso8601String().split("T")[0],
        endDate: endDate!.toIso8601String().split("T")[0],
        notes: reasonC.text,
        employee: {
          "name": nameC.text,
          "position": positionC.text,
          "department": deptC.text,
        },
      );

      final res = await LeaveRequestService.instance.submitLeave(payload);

      // ✅ Always setState to stop loading
      if (mounted) {
        setState(() => submitting = false);
      }

      if (res.success) {
        if (mounted) {
          _snack(res.message);
          // ✅ Add slight delay before pop to show snackbar
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            context.go('/home'); // ✅ Navigate back to home with refresh
          }
        }
      } else {
        if (mounted) {
          _snack(res.message, error: true);
        }
      }
    } catch (e) {
      // ✅ Handle error and stop loading
      if (mounted) {
        setState(() => submitting = false);
        _snack("Terjadi kesalahan: $e", error: true);
      }
    }
  }

  void _snack(String msg, {bool error = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: error ? Colors.red : Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    nameC.dispose();
    positionC.dispose();
    deptC.dispose();
    reasonC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat("dd/MM/yy");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00A8E8),
        foregroundColor: Colors.white,
        title: const Text("Surat Izin"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        centerTitle: true,
      ),
      body: _loadingProfile
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<ApiResponse<List<LeaveType>>>(
              future: leaveTypesFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.data!.success) {
                  return Center(child: Text(snapshot.data!.message));
                }

                final types = snapshot.data!.data!;

                return Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _fieldLabel("Nama Karyawan"),
                            _input(nameC, readOnly: true),

                            _fieldLabel("Jabatan"),
                            _input(positionC, readOnly: true),

                            _fieldLabel("Departemen"),
                            _input(deptC, readOnly: true),

                            _fieldLabel("Jenis Izin"),
                            _dropdown(types),

                            _fieldLabel("Alasan Izin"),
                            _input(reasonC, maxLines: 3),

                            _fieldLabel("Tanggal Mulai"),
                            _dateButton(
                              startDate != null
                                  ? df.format(startDate!)
                                  : "dd/mm/yy",
                              () => pickDate(true),
                            ),

                            _fieldLabel("Tanggal Selesai"),
                            _dateButton(
                              endDate != null
                                  ? df.format(endDate!)
                                  : "dd/mm/yy",
                              () => pickDate(false),
                            ),

                            const SizedBox(height: 20),

                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: submitting ? null : submit,
                                child: submitting
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        "Simpan",
                                        style: TextStyle(color: Colors.white),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // ✅ Full screen overlay when submitting
                    if (submitting)
                      Container(
                        color: Colors.black26,
                        child: const Center(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text('Mengirim pengajuan izin...'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
    );
  }

  // ---------- UI COMPONENTS ----------

  Widget _fieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(label, style: const TextStyle(fontSize: 15)),
      ),
    );
  }

  Widget _input(
    TextEditingController c, {
    int maxLines = 1,
    bool readOnly = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: readOnly ? Colors.grey.shade300 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextFormField(
        controller: c,
        maxLines: maxLines,
        readOnly: readOnly,
        decoration: const InputDecoration(border: InputBorder.none),
        validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
      ),
    );
  }

  Widget _dropdown(List<LeaveType> types) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<LeaveType>(
        decoration: const InputDecoration(border: InputBorder.none),
        value: _selectedType,
        items: types
            .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
            .toList(),
        onChanged: (v) => setState(() => _selectedType = v),
      ),
    );
  }

  Widget _dateButton(String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, size: 18),
            const SizedBox(width: 12),
            Text(value),
          ],
        ),
      ),
    );
  }
}