import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> currencies = [];
  List<Map<String, dynamic>> filteredCurrencies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCurrencies();
  }

  Future<void> fetchCurrencies() async {
    const String apiUrl = "https://api.exchangerate-api.com/v4/latest/USD";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;

        final List<Map<String, dynamic>> currencyList =
            rates.entries.map((entry) {
          return {
            "Code": entry.key,
            "Rate": entry.value.toString(),
          };
        }).toList();

        setState(() {
          currencies = currencyList;
          filteredCurrencies = currencyList;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load currency data");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  void _filterCurrencies(String query) {
    final results = currencies
        .where((currency) =>
            currency["Code"]!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredCurrencies = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text("Currency Details"),
        backgroundColor: Colors.teal,
        elevation: 5,
      ),
      body: isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.teal,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Loading currencies...",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: (value) => _filterCurrencies(value),
                      decoration: InputDecoration(
                        labelText: "Search Currency",
                        hintText: "Enter currency code (e.g., USD)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.teal),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: filteredCurrencies.isNotEmpty
                          ? Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFE3F2FD),
                                      Color(0xFFBBDEFB),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: SingleChildScrollView(
                                  child: DataTable(
                                    headingRowColor:
                                        WidgetStateProperty.resolveWith(
                                      (states) => Colors.teal.withOpacity(0.8),
                                    ),
                                    dataRowColor:
                                        WidgetStateProperty.resolveWith(
                                      (states) => Colors.white,
                                    ),
                                    columnSpacing: 20,
                                    columns: const [
                                      DataColumn(
                                        label: Text(
                                          "Code",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "Rate (to USD)",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: filteredCurrencies.map((currency) {
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            Text(
                                              currency["Code"]!,
                                              style: const TextStyle(
                                                color: Colors.teal,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              currency["Rate"]!,
                                              style: const TextStyle(
                                                color: Colors.teal,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            )
                          : const Center(
                              child: Text(
                                "No currencies found.",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
