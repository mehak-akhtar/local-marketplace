import 'package:flutter/material.dart';
import 'package:olxapp/main_screens/sell_subscreens/sell_price_screen.dart';

class SellDetailsScreen extends StatelessWidget {
  const SellDetailsScreen({Key? key}) : super(key: key);

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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3A5F),
                      borderRadius: BorderRadius.circular(8),
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
                  _buildDropdownField('Brand'),
                  const SizedBox(height: 16),
                  _buildDropdownField('Model'),
                  const SizedBox(height: 16),
                  _buildDropdownField('Variant'),
                  const SizedBox(height: 16),
                  _buildDropdownField('Year'),
                  const SizedBox(height: 16),
                  _buildDropdownField('Transmission Type'),
                  const SizedBox(height: 16),
                  _buildDropdownField('Fuel Type'),
                  const SizedBox(height: 16),
                  _buildDropdownField('KM Driven'),
                  const SizedBox(height: 16),
                  _buildDropdownField('Set Location'),
                  const SizedBox(height: 30),
                  // Get car price Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SellPriceScreen(),
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

  Widget _buildDropdownField(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8C87C),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF1E3A5F),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E3A5F),
            ),
          ),
          DropdownButton<String>(
            isExpanded: true,
            underline: const SizedBox(),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF1E3A5F),
            ),
            items: const [],
            onChanged: (value) {},
            hint: const Text(''),
          ),
        ],
      ),
    );
  }
}