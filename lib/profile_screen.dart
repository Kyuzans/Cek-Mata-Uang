import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Made By:",
              style: TextStyle(
                color: Colors.teal,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 80,
                backgroundImage: const AssetImage('images/profile_bg.jpg'),
                backgroundColor: Colors.teal[100],
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "Nama: Muhammad Syafiq Dhiyaa Adlan ",
              style: TextStyle(
                color: Colors.blueGrey[800],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "NIM: 21120122140160",
              style: TextStyle(
                color: Colors.blueGrey[800],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Jurusan: Teknik Komputer",
              style: TextStyle(
                color: Colors.blueGrey[800],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Kontak: - WA 081288923519",
              style: TextStyle(
                color: Colors.blueGrey[800],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
