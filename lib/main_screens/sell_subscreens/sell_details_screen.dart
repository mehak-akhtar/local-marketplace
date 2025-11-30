import 'package:flutter/material.dart';
import 'package:olxapp/main_screens/sell_subscreens/sell_price_screen.dart';

class SellDetailsScreen extends StatefulWidget {
  const SellDetailsScreen({Key? key}) : super(key: key);

  @override
  State<SellDetailsScreen> createState() => _SellDetailsScreenState();
}

class _SellDetailsScreenState extends State<SellDetailsScreen> {
  // Map to store all form data
  final Map<String, String> carDetails = {
    'Brand': '',
    'Model': '',
    'Variant': '',
    'Year': '',
    'Transmission Type': '',
    'Fuel Type': '',
    'KM Driven': '',
    'Set Location': '',
  };

  // Text controllers for each field
  final Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each field
    carDetails.keys.forEach((key) {
      controllers[key] = TextEditingController();
      // Add listener to update the map when text changes
      controllers[key]! .addListener(() {
        carDetails[key] = controllers[key]!.text;
      });
    });
  }

  @override
  void dispose() {
    // Dispose all controllers
    controllers.values.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
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
                mainAxisAlignment: MainAxisAlignment. spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3A5F),
                      borderRadius: BorderRadius. circular(8),
                    ),
                    child: const Text(
                      'GC',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE8C87C),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Color(0xFF1E3A5F),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            // Form Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildTextField('Brand'),
                  const SizedBox(height: 16),
                  _buildTextField('Model'),
                  const SizedBox(height: 16),
                  _buildTextField('Variant'),
                  const SizedBox(height: 16),
                  _buildTextField('Year'),
                  const SizedBox(height: 16),
                  _buildTextField('Transmission Type'),
                  const SizedBox(height: 16),
                  _buildTextField('Fuel Type'),
                  const SizedBox(height: 16),
                  _buildTextField('KM Driven'),
                  const SizedBox(height: 16),
                  _buildTextField('Set Location'),
                  const SizedBox(height: 30),
                  // Get car price Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Print the data (for debugging)
                        print('Car Details from sell_details_screen: $carDetails');

                        // Navigate to next screen with the data
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SellPriceScreen(
                              carDetails: Map<String, String>.from(carDetails),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A5F),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Get car price',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8C87C),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF1E3A5F),
          width: 2,
        ),
      ),
      child: TextField(
        controller: controllers[label],
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E3A5F),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF1E3A5F),
        ),
        keyboardType: label == 'Year' || label == 'KM Driven'
            ? TextInputType. number
            : TextInputType. text,
      ),
    );
  }
}