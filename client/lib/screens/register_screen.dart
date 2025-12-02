import 'package:client/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController jabatanController = TextEditingController();
  final TextEditingController departemenController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? jenisKelamin;
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Daftar Akun Karyawan"),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// LOGO
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Center(
                  child: SizedBox(
                    height: 60,
                    child: Image.asset(
                      'assets/logoo.png', // ganti sesuai path logomu
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const Text(
                "Daftar akun karyawan\n*hanya admin yang bisa menambahkan data",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 20),

              _buildTextField("Nama Panjang", namaController),
              _buildTextField("Email", emailController),

              _buildDropdownGender(),

              _buildTextField("Alamat", alamatController),
              _buildTextField("Jabatan", jabatanController),
              _buildTextField("Departemen", departemenController),

              _buildPasswordField(),

              const SizedBox(height: 25),

              /// BUTTON DAFTAR
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0094FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // TODO: tambahkan fungsi register
                  },
                  child: const Text(
                    "Daftar Karyawan Baru",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ================== WIDGETS ==================

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownGender() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Jenis Kelamin",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: jenisKelamin,
                hint: const Text("Pilih"),
                items: const [
                  DropdownMenuItem(value: "Pria", child: Text("Pria")),
                  DropdownMenuItem(value: "Wanita", child: Text("Wanita")),
                ],
                onChanged: (value) {
                  setState(() => jenisKelamin = value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Set Password",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: passwordController,
            obscureText: isObscure,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade100,
              suffixIcon: IconButton(
                icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() => isObscure = !isObscure);
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
