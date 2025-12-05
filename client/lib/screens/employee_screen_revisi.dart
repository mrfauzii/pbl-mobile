import 'package:flutter/material.dart';
import 'package:client/widgets/custom_button.dart';
import 'package:client/widgets/custom_card.dart';

class EmployeeScreenRevisi extends StatelessWidget {
  final List<Map<String, String>> employees;

  const EmployeeScreenRevisi({super.key, this.employees = const []});

  @override
  Widget build(BuildContext context) {
    final data = employees.isNotEmpty
        ? employees
        : List.generate(
            4,
            (index) => {
              "name": ["Andi Budi Carmen", "Budi", "Carmen", "Dodfi"][index],
              "position": "Front-End Developer",
            },
          );

    return Scaffold(
      backgroundColor: const Color(0xFF22A9D6),
      body: Column(
        children: [
          // ===================== HEADER BIRU =====================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
            decoration: const BoxDecoration(
              color: Color(0xFF22A9D6),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Daftar\nKaryawan",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Daftar seluruh data karyawan \n*Hanya admin yang bisa menambah data",
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Image.asset('assets/logoPbl.png', width: 50, height: 50),
              ],
            ),
          ),

          // ===================== KONTEN =====================
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      backgroundColor: const Color(0xFF22A9D6),
                      child: const Text(
                        "Tambah Data Karyawan",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {},
                    ),
                  ),

                  const SizedBox(height: 20),

                  // List Karyawan
                  Expanded(
                    child: ListView.separated(
                      itemCount: data.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return CustomCard(
                          name: data[index]['name']!,
                          position: data[index]['position']!,
                          onTap: () {},
                          actionIcon: Icons.edit,
                          onActionTap: () {
                            print("Edit diklik untuk ${data[index]['name']}");
                          },
                          onInfoTap: () {
                            print("Info diklik untuk ${data[index]['name']}");
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
