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

  // Dropdown options
  final List<String> transmissionTypes = ['Manual', 'Automatic', 'CVT', 'Semi-Automatic'];
  final List<String> fuelTypes = ['Petrol', 'Diesel', 'Electric', 'Hybrid', 'CNG', 'LPG'];

  @override
  void initState() {
    super.initState();
    // Initialize controllers for text fields only (not dropdowns)
    final textFields = ['Brand', 'Model', 'Variant', 'Year', 'KM Driven', 'Set Location'];
    for (var key in textFields) {
      controllers[key] = TextEditingController();
      controllers[key]!.addListener(() {
        carDetails[key] = controllers[key]!.text;
      });
    }
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
                  _buildDropdown('Transmission Type', transmissionTypes),
                  const SizedBox(height: 16),
                  _buildDropdown('Fuel Type', fuelTypes),
                  const SizedBox(height: 16),
                  _buildTextField('KM Driven'),
                  const SizedBox(height: 16),
                  _buildTextField('Set Location'),
                  const SizedBox(height: 30),
                  // Get car price Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _validateAndNavigate,
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

  // Validate all fields before navigation
  void _validateAndNavigate() {
    // Validate Brand
    if (carDetails['Brand']?.trim().isEmpty ?? true) {
      _showError('Brand is required');
      return;
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(carDetails['Brand']!)) {
      _showError('Brand must contain only letters');
      return;
    }

    // Validate Model
    if (carDetails['Model']?.trim().isEmpty ?? true) {
      _showError('Model is required');
      return;
    }

    // Validate Variant
    if (carDetails['Variant']?.trim().isEmpty ?? true) {
      _showError('Variant is required');
      return;
    }

    // Validate Year
    if (carDetails['Year']?.trim().isEmpty ?? true) {
      _showError('Year is required');
      return;
    }
    final year = int.tryParse(carDetails['Year']!);
    if (year == null) {
      _showError('Year must be a valid number');
      return;
    }
    if (year < 1900 || year > 2025) {
      _showError('Year must be between 1900 and 2025');
      return;
    }

    // Validate Transmission Type
    if (carDetails['Transmission Type']?.trim().isEmpty ?? true) {
      _showError('Transmission Type is required');
      return;
    }

    // Validate Fuel Type
    if (carDetails['Fuel Type']?.trim().isEmpty ?? true) {
      _showError('Fuel Type is required');
      return;
    }

    // Validate KM Driven
    if (carDetails['KM Driven']?.trim().isEmpty ?? true) {
      _showError('KM Driven is required');
      return;
    }
    final kmDriven = int.tryParse(carDetails['KM Driven']!);
    if (kmDriven == null) {
      _showError('KM Driven must be a valid number');
      return;
    }
    if (kmDriven < 0) {
      _showError('KM Driven must be a positive number');
      return;
    }

    // Validate Location
    if (carDetails['Set Location']?.trim().isEmpty ?? true) {
      _showError('Location is required');
      return;
    }

    // All validations passed, navigate to next screen
    print('Car Details from sell_details_screen: $carDetails');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SellPriceScreen(
          carDetails: Map<String, String>.from(carDetails),
        ),
      ),
    );
  }

  // Show error message
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
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
            ? TextInputType.number
            : TextInputType.text,
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> options) {
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
      child: DropdownButtonFormField<String>(
        value: carDetails[label]?.isNotEmpty == true ? carDetails[label] : null,
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
        dropdownColor: const Color(0xFFE8C87C),
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF1E3A5F),
        ),
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            carDetails[label] = newValue ?? '';
          });
        },
      ),
    );
  }
}