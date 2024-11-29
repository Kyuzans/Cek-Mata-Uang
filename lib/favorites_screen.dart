import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  final List<String> favoriteCurrencies;

  const FavoritesScreen({Key? key, required this.favoriteCurrencies})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favorites",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF6F8FB),
      body: favoriteCurrencies.isEmpty
          ? Center(
              child: Text(
                "No favorites added yet!",
                style: TextStyle(
                  color: Colors.blueGrey[800],
                  fontSize: 18,
                ),
              ),
            )
          : ListView.builder(
              itemCount: favoriteCurrencies.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      favoriteCurrencies[index],
                      style: const TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: const Icon(
                      Icons.favorite,
                      color: Colors.redAccent,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
