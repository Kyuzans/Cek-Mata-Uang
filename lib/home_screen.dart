import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'about_screen.dart';
import 'detail_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);

  String fromCurrency = "USD";
  String toCurrency = "EUR";
  double rate = 0.0;
  double total = 0.0;
  TextEditingController amountController = TextEditingController();
  List<String> currencies = [];
  bool isLoading = false;
  List<String> favoriteCurrencies = [];

  @override
  void initState() {
    super.initState();
    _getCurrencies();
  }

  Future<void> _getCurrencies() async {
    setState(() {
      isLoading = true;
    });

    var response = await http
        .get(Uri.parse('https://api.exchangerate-api.com/v4/latest/USD'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        currencies = (data['rates'] as Map<String, dynamic>).keys.toList();
        rate = data['rates'][toCurrency];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      _showErrorMessage('Failed to load currencies');
    }
  }

  Future<void> _getRate() async {
    setState(() {
      isLoading = true;
    });

    var response = await http.get(
        Uri.parse('https://api.exchangerate-api.com/v4/latest/$fromCurrency'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        rate = data['rates'][toCurrency];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      _showErrorMessage('Failed to load exchange rate');
    }
  }

  void _swapCurrencies() {
    setState(() {
      String temp = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = temp;
      _getRate();
    });
  }

  void _addToFavorites() {
    String favorite = "$fromCurrency -> $toCurrency";
    if (!favoriteCurrencies.contains(favorite)) {
      setState(() {
        favoriteCurrencies.add(favorite);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$favorite added to favorites!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$favorite is already in favorites!')),
      );
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 1
          ? AppBar(
              title: const Text("Currency Converter"),
              backgroundColor: const Color(0xFF4CAF50),
              actions: [
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  tooltip: "About",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AboutScreen()),
                    );
                  },
                ),
              ],
            )
          : null,
      backgroundColor: const Color(0xFFF6F8FB),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          const DetailScreen(),
          _buildHomePage(context),
          FavoritesScreen(favoriteCurrencies: favoriteCurrencies),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.jumpToPage(index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF4CAF50),
        unselectedItemColor: const Color(0xFF9E9E9E),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: "Detail",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: "Home",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorites",
          ),
        ],
      ),
    );
  }

  Widget _buildHomePage(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(40),
              child: Image.asset(
                'images/currency_bg.jpg',
                width: MediaQuery.of(context).size.width / 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Card(
                color: const Color(0xFFE1F5FE),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Amount",
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCurrencyDropdown(fromCurrency, (newValue) {
                    setState(() {
                      fromCurrency = newValue!;
                      _getRate();
                    });
                  }),
                  IconButton(
                    onPressed: _swapCurrencies,
                    icon: const Icon(Icons.swap_horiz),
                    iconSize: 40,
                    color: Colors.teal,
                  ),
                  _buildCurrencyDropdown(toCurrency, (newValue) {
                    setState(() {
                      toCurrency = newValue!;
                      _getRate();
                    });
                  }),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (amountController.text.isNotEmpty) {
                  setState(() {
                    double amount = double.parse(amountController.text);
                    total = amount * rate;
                  });
                } else {
                  _showErrorMessage("Please enter a valid amount!");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
              ),
              child: const Text("Convert"),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const CircularProgressIndicator(
                color: Colors.teal,
              )
            else
              Text(
                "Rate: $rate",
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
            const SizedBox(height: 20),
            Text(
              '${total.toStringAsFixed(3)}',
              style: const TextStyle(color: Colors.teal, fontSize: 40),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addToFavorites,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              child: const Text("Add to Favorites"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyDropdown(String value, Function(String?) onChanged) {
    return SizedBox(
      width: 120,
      child: Card(
        color: const Color(0xFFE1F5FE),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFFF6F8FB),
          style: const TextStyle(color: Colors.black),
          iconEnabledColor: Colors.teal,
          items: currencies.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
