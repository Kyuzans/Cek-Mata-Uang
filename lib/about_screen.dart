import 'package:flutter/material.dart';
import 'profile_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF6F8FB),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tentang Aplikasi",
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Aplikasi ini adalah konverter mata uang yang memungkinkan pengguna untuk mengonversi jumlah dari satu mata uang ke mata uang lain. Aplikasi ini dibangun menggunakan bahasa pemrograman Dart, dengan memanfaatkan API dari https://api.exchangerate-api.com/.",
                style: TextStyle(
                  color: Colors.blueGrey[800],
                  fontSize: 18,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Aplikasi ini memiliki 5 halaman utama, yaitu:",
                style: TextStyle(
                  color: Colors.blueGrey[800],
                  fontSize: 18,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "- Home Screen\n"
                "- Detail Screen\n"
                "- Favorites Screen\n"
                "- Profile Screen\n"
                "- About Screen",
                style: TextStyle(
                  color: Colors.blueGrey[800],
                  fontSize: 18,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Fitur Utama:",
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "- Konversi mata uang secara real-time.\n"
                "- Penambahan mata uang ke dalam daftar favorit.\n"
                "- Tampilan detail profil aplikasi.\n"
                "- Navigasi antar halaman dengan UI yang responsif.",
                style: TextStyle(
                  color: Colors.blueGrey[800],
                  fontSize: 18,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Center(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              },
              child: const Text(
                "Made By",
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
