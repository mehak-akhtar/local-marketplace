import 'dart:io';
import 'package:flutter/material.dart';
import 'package:olxapp/main_screens/sell_subscreens/sell_options.dart';

class SellPriceScreen extends StatefulWidget {
  // Accept a dynamic map so we can store lists (images) and numbers/strings
  final Map<String, dynamic> carDetails;

  const SellPriceScreen({
    Key? key,
    required this.carDetails,
  }) : super(key: key);

  @override
  State<SellPriceScreen> createState() => _SellPriceScreenState();
}

class _SellPriceScreenState extends State<SellPriceScreen> {
  late Map<String, dynamic> updatedCarDetails;
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // copy incoming map so we don't mutate the original reference unexpectedly
    updatedCarDetails = Map<String, dynamic>. from(widget.carDetails);

    // If there's an estimated price, prefill it in the price field
    final existingPrice = (updatedCarDetails['Estimated Price'] ?? updatedCarDetails['EstimatedPrice'] ?? '').toString();
    if (existingPrice.isNotEmpty) {
      _priceController.text = existingPrice;
    }

    // mark screen for debugging
    updatedCarDetails['Screen'] = 'Price Screen';
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  // Navigate to next screen and pass updated map
  void _goToSellOptions() {
    // set the price (user-entered)
    final priceInput = _priceController.text.trim();
    if (priceInput.isNotEmpty) {
      updatedCarDetails['Price'] = priceInput;
    } else {
      // remove existing key if empty
      updatedCarDetails.remove('Price');
    }

    // debug print
    debugPrint('Navigating to sell_options with data: $updatedCarDetails');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SellOptionsScreen(
          carDetails: Map<String, dynamic>.from(updatedCarDetails),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8C87C),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3A5F),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'GC',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFE8C87C)),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu, color: Color(0xFF1E3A5F)),
                    onPressed:  () {},
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    // Price Section
                    const Text(
                      'Sell your car up to',
                      style: TextStyle(fontSize: 18, fontWeight:  FontWeight.w600, color: Color(0xFF1E3A5F)),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixText:  'RS: ',
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Enter your asking price',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Book for free inspection Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _goToSellOptions,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A5F),
                          padding: const EdgeInsets. symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        child: const Text(
                          'Book for free inspection',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight. w600, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Happy customer Section
                    const Align(
                      alignment: Alignment. centerLeft,
                      child:  Text(
                        'Happy customer',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF1E3A5F)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Customer Images
                    SingleChildScrollView(
                      scrollDirection: Axis. horizontal,
                      child: Row(
                        children: List. generate(
                          3,
                              (index) => Container(
                            width: 120,
                            height: 100,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E3A5F),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(Icons.person, size: 40, color: Color(0xFFE8C87C)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}