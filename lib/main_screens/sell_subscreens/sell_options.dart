import 'package:flutter/material.dart';
import 'package:olxapp/main_screens/sell_subscreens/sell_car_details.dart';

class SellOptionsScreen extends StatefulWidget {
  final Map<String, String> carDetails;

  const SellOptionsScreen({
    Key? key,
    required this.carDetails,
  }) : super(key: key);

  @override
  State<SellOptionsScreen> createState() => _SellOptionsScreenState();
}

class _SellOptionsScreenState extends State<SellOptionsScreen> {
  int _currentImageIndex = 0;
  late Map<String, String> updatedCarDetails;

  String? selectedAddress;
  String? selectedPinCode;
  bool autoDetectEnabled = false;
  List<String> uploadedImages = [];

  @override
  void initState() {
    super.initState();
    // Copy the received map and prepare to add new fields
    updatedCarDetails = Map<String, String>. from(widget.carDetails);

    print('Car Details in sell_options: $updatedCarDetails');
  }

  void _updateMapWithOptions() {
    // Add fields specific to this screen
    if (selectedAddress != null) {
      updatedCarDetails['Address'] = selectedAddress!;
    }
    if (selectedPinCode != null) {
      updatedCarDetails['Pin Code'] = selectedPinCode! ;
    }
    updatedCarDetails['Auto Detect'] = autoDetectEnabled. toString();
    updatedCarDetails['Images Uploaded'] = uploadedImages.length.toString();
    updatedCarDetails['Screen'] = 'Options Screen';

    print('Updated Car Details in sell_options: $updatedCarDetails');
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
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Car Image Slider
                    Stack(
                      children: [
                        Container(
                          height: 180,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Icon(
                                  Icons.directions_car,
                                  size: 70,
                                  color: Colors.grey[600],
                                ),
                              ),
                              // Navigation Arrows
                              Positioned(
                                left: 8,
                                top: 0,
                                bottom: 0,
                                child: Center(
                                  child: IconButton(
                                    icon: const Icon(Icons.arrow_back_ios),
                                    color: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        if (_currentImageIndex > 0) {
                                          _currentImageIndex--;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 8,
                                top: 0,
                                bottom: 0,
                                child: Center(
                                  child: IconButton(
                                    icon: const Icon(Icons.arrow_forward_ios),
                                    color: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        if (_currentImageIndex < 2) {
                                          _currentImageIndex++;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              // Location Badge
                              Positioned(
                                bottom: 12,
                                left: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        widget.carDetails['Set Location'] ?? 'Tamilnadu/salem',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              3,
                                  (index) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index == _currentImageIndex
                                      ? const Color(0xFF1E3A5F)
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Set Location / Upload Image Label
                    const Text(
                      'Set Location / Upload Image',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E3A5F),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Action Buttons
                    _buildActionButton('Address', () {
                      setState(() {
                        selectedAddress = 'Sample Address 123';
                      });
                    }),
                    const SizedBox(height: 16),
                    _buildActionButton('Pin code', () {
                      setState(() {
                        selectedPinCode = '636007';
                      });
                    }),
                    const SizedBox(height: 16),
                    _buildActionButton('Auto detect', () {
                      setState(() {
                        autoDetectEnabled = !autoDetectEnabled;
                      });
                    }),
                    const SizedBox(height: 16),
                    _buildActionButton('Upload Image', () {
                      setState(() {
                        uploadedImages.add('image_${uploadedImages.length + 1}');
                      });
                    }),
                    const SizedBox(height: 30),
                    // Next Button with Arrow
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _updateMapWithOptions();

                          print('Navigating to sell_car_details with data: $updatedCarDetails');

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SellCarDetailsScreen(
                                carDetails: Map<String, String>.from(updatedCarDetails),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton. styleFrom(
                          backgroundColor: const Color(0xFF1E3A5F),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight. w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
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

  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double. infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E3A5F),
          padding: const EdgeInsets. symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}