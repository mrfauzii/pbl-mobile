import 'package:client/services/change_password_service.dart';
import 'package:client/utils/api_wrapper.dart';
import 'package:client/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  ForgotPasswordScreen({super.key});

  Future<void> handleSendToken(BuildContext context, String email) async {
    ApiResponse response = await ChangePasswordService.instance.getToken(email);

    if (!context.mounted) return;
    if (!response.success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(response.message)));
  }

  Future<void> handleCheckToken(BuildContext context, String token) async {
    ApiResponse response = await ChangePasswordService.instance.checkToken(
      token,
    );
    if (!context.mounted) return;
    if (!response.success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(response.message)));

    context.push("/change-password");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: ""),
      backgroundColor: const Color(0xFF22A9D6),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),

                  // LOGO
                  Row(children: [Image.asset('assets/logo.png', height: 45)]),

                  const SizedBox(height: 25),

                  // TITLE
                  const Text(
                    "Lupa Password",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Isi email yang terhubung untuk autentikasi\npenggantian password",
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),

                  const SizedBox(height: 30),

                  // ================= WHITE FORM CARD =================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: FormBuilder(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ================= EMAIL =================
                          const Text(
                            "Email",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF22A9D6),
                                width: 1,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                // EMAIL FIELD
                                Expanded(
                                  child: FormBuilderTextField(
                                    name: 'email',
                                    keyboardType: TextInputType.emailAddress,
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(
                                        errorText: "Email wajib diisi",
                                      ),
                                      FormBuilderValidators.email(
                                        errorText: "Format email tidak valid",
                                      ),
                                    ]),
                                    decoration: const InputDecoration(
                                      hintText: "example@gmail.com",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // SEND EMAIL BUTTON
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                      0xFF22A9D6,
                                    ), // solid color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                  ),
                                  onPressed: () async {
                                    final state = _formKey.currentState;
                                    if (state == null) return;

                                    final emailField = state.fields['email'];
                                    final isValid =
                                        emailField?.validate() ?? false;

                                    if (!isValid) return;

                                    final email =
                                        emailField?.value?.toString() ?? '';

                                    // TODO: call API to send reset email
                                    await handleSendToken(context, email);
                                  },
                                  child: const Text(
                                    "Kirim",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ================= TOKEN INPUT =================
                          const Text(
                            "Token",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF22A9D6),
                                width: 1,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            child: FormBuilderTextField(
                              name: 'token',
                              keyboardType: TextInputType.text,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Token wajib diisi",
                                ),
                                FormBuilderValidators.minLength(
                                  4,
                                  errorText: "Token minimal 4 karakter",
                                ),
                              ]),
                              decoration: const InputDecoration(
                                hintText: "Masukkan token verifikasi",
                                hintStyle: TextStyle(color: Colors.grey),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ================= SUBMIT BUTTON =================
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF22A9D6), Color(0xFF22A9D6)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xFF22A9D6),
                                  blurRadius: 5,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              onPressed: () async {
                                final isValid =
                                    _formKey.currentState?.saveAndValidate() ??
                                    false;

                                if (!isValid) return;

                                final formValue = _formKey.currentState!.value;

                                final token =
                                    formValue['token']?.toString() ?? '';

                                // TODO: send email + token to backend
                                await handleCheckToken(context, token);
                              },
                              child: const Text(
                                "Ganti Password",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
