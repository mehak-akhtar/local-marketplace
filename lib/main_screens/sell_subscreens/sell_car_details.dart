import 'package:flutter/material.dart';
import 'package:olxapp/main_screens/sell_subscreens/sell_inspection.dart';

class SellCarDetailsScreen extends StatefulWidget {
  const SellCarDetailsScreen({Key? key}) : super(key: key);

  @override
  State<SellCarDetailsScreen> createState() => _SellCarDetailsScreenState();
}

class _SellCarDetailsScreenState extends State<SellCarDetailsScreen> {
  int _currentImageIndex = 0;

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
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Tamilnadu/salem',
                                        style: TextStyle(
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
                    // Estimated Price
                    const Text(
                      'Estimated price:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E3A5F),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'RS: 18,000,00',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A5F),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Car Details Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Car details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E3A5F),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Mercedes-Benz GLA',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E3A5F),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '2,6,600 KM  •  Diesel  •  Tamil Nadu',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF1E3A5F),
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Transmission',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF666666),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Auto',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1E3A5F),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Engine Capacity',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF666666),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '1498 cc',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1E3A5F),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(
                                color: Color(0xFF1E3A5F),
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'Free Inspection',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E3A5F),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SellInspectionScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E3A5F),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'List My Car',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
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