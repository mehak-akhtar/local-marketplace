import 'package:flutter/material.dart';
import '../filter_screen.dart';
import 'car_details/car_details.dart';

class BuyScreen extends StatelessWidget {
  const BuyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              color: const Color(0xFFE8C87C),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Top Bar with Logo and Menu
                  Row(
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
                        onPressed: () {
                          _showFilterBottomSheet(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD54F),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Choose',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF1E3A5F),
                                ),
                              ),
                              const Text(
                                'you Favorite Car',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E3A5F),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1E3A5F),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                ),
                                child: const Text(
                                  'Know more',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 60),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Car Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemCount: 9, // 3x3 grid
                itemBuilder: (context, index) {
                  return _buildCarCard(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(),
    );
  }

  Widget _buildCarCard(BuildContext context) {
    return GestureDetector(
      onTap: (){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CarDetailsScreen(),
        ),
      );
    },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF2196F3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Image
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.directions_car,
                      size: 40,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Positioned(
                    top: 6,
                    right: 6,
                    child: Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Audi Q7',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A5F),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Location: Dubai',
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Fuel: Petrol',
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'IZS 5 Lakh',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A5F),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CarDetailsScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A5F),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'View car',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 2),
                            Icon(Icons.arrow_forward, size: 10, color: Colors.white),
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
}