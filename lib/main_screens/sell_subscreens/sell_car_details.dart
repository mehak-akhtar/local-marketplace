import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olxapp/main_screens/sell_subscreens/sell_inspection.dart';

class SellCarDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> carDetails;

  const SellCarDetailsScreen({Key? key, required this.carDetails})
      : super(key: key);

  @override
  State<SellCarDetailsScreen> createState() => _SellCarDetailsScreenState();
}

class _SellCarDetailsScreenState extends State<SellCarDetailsScreen> {
  int _currentImageIndex = 0;
  late Map<String, dynamic> updatedCarDetails;
  bool _isListingCar = false; // Loading state

  @override
  void initState() {
    super.initState();
    // Copy the received map and prepare to add new fields
    updatedCarDetails = Map<String, dynamic>.from(widget.carDetails);

    // ✅ FIXED:  Use actual car data instead of placeholders
    // Only set Car Name if not already provided
    if (! updatedCarDetails. containsKey('Car Name') ||
        updatedCarDetails['Car Name']?.toString().trim().isEmpty == true) {
      updatedCarDetails['Car Name'] = '${updatedCarDetails['Brand'] ??  ''} ${updatedCarDetails['Model'] ?? ''}'. trim();
    }

    // Set Engine Capacity if not provided (placeholder for now)
    if (!updatedCarDetails.containsKey('Engine Capacity') ||
        updatedCarDetails['Engine Capacity']?. toString().trim().isEmpty == true) {
      updatedCarDetails['Engine Capacity'] = 'N/A';
    }

    // Use the user-entered price or a default
    if (!updatedCarDetails.containsKey('Final Estimated Price') ||
        updatedCarDetails['Final Estimated Price']?.toString().trim().isEmpty == true) {
      updatedCarDetails['Final Estimated Price'] = updatedCarDetails['Price'] ?? 'Contact for price';
    }

    updatedCarDetails['Screen'] = 'Car Details Screen';

    print('Car Details in sell_car_details:  $updatedCarDetails');
  }

  // Validate required fields
  bool _validateCarDetails() {
    // Check if essential fields are present and not empty
    final requiredFields = ['Brand', 'Model', 'Year', 'KM Driven', 'Set Location'];

    for (String field in requiredFields) {
      if (!updatedCarDetails.containsKey(field) ||
          updatedCarDetails[field]?.isEmpty == true) {
        _showSnackBar(
          '❌ Missing required field: $field',
          Colors.red,
        );
        return false;
      }
    }
    return true;
  }

  // Get current user data
  Future<Map<String, dynamic>> _getCurrentUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw 'No user logged in';
      }

      // Get user data from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        // If user document doesn't exist, use basic auth data
        return {
          'seller_uid': user.uid,
          'seller_name': user.displayName ?? 'Unknown User',
          'seller_email': user.email ?? '',
        };
      }

      // Get name from Firestore document
      final userData = userDoc.data()!;

      return {
        'seller_uid': user.uid,
        'seller_name': userData['name'] ?? user.displayName ?? 'Unknown User',
        'seller_email': user.email ?? '',
      };
    } catch (e) {
      print('❌ Error getting user data: $e');
      rethrow;
    }
  }

  // List car to Firestore with proper error handling
  Future<void> _listCarToFirestore() async {
    // Validate required fields first
    if (!_validateCarDetails()) {
      return;
    }

    setState(() {
      _isListingCar = true;
    });

    try {
      // Get current user data
      final userData = await _getCurrentUserData();

      // Prepare the final car data with all required fields
      final carData = {
        // Basic car details
        'Brand': updatedCarDetails['Brand'],
        'Model': updatedCarDetails['Model'],
        'Variant': updatedCarDetails['Variant'],
        'Year': int.tryParse(updatedCarDetails['Year'].toString()) ?? 0,
        'Transmission Type': updatedCarDetails['Transmission Type'],
        'Fuel Type': updatedCarDetails['Fuel Type'],
        'KM Driven': int.tryParse(updatedCarDetails['KM Driven'].toString()) ?? 0,
        'Set Location': updatedCarDetails['Set Location'],
        
        // Car name and pricing
        'Car Name': updatedCarDetails['Car Name'] ?? '${updatedCarDetails['Brand']} ${updatedCarDetails['Model']}',
        'Price': updatedCarDetails['Price'] ?? '',
        'Estimated Price': updatedCarDetails['Estimated Price'] ?? updatedCarDetails['Price'] ?? '',
        'Final Estimated Price': updatedCarDetails['Final Estimated Price'] ?? updatedCarDetails['Price'] ?? '',
        
        // Optional details
        'Address': updatedCarDetails['Address'] ?? '',
        'Pin Code': updatedCarDetails['Pin Code'] ?? '',
        'Engine Capacity': updatedCarDetails['Engine Capacity'] ?? 'N/A',
        
        // Seller information
        'seller_uid': userData['seller_uid'],
        'seller_name': userData['seller_name'],
        'seller_email': userData['seller_email'],
        
        // Status and timestamp
        'status': 'active',
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Add car to Firestore 'global' collection
      final docRef = await FirebaseFirestore.instance
          .collection('global')
          .add(carData);

      print('✅ Car listed successfully with ID: ${docRef.id}');

      if (mounted) {
        setState(() {
          _isListingCar = false;
        });

        // Show success message
        _showSnackBar(
          '✅ Car listed successfully! Your car is now visible to buyers.',
          Colors.green,
        );

        // Navigate to home screen after a short delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            // Pop all screens and go back to home
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        });
      }
    } on FirebaseException catch (e) {
      // Handle Firebase-specific errors
      print('❌ Firebase Error: ${e.code} - ${e.message}');

      String errorMessage;
      switch (e.code) {
        case 'permission-denied':
          errorMessage = '❌ Permission denied. Please check your Firestore security rules.';
          break;
        case 'unavailable':
          errorMessage = '❌ Service unavailable. Please check your internet connection.';
          break;
        case 'deadline-exceeded':
          errorMessage = '❌ Request timeout. Please try again.';
          break;
        case 'not-found':
          errorMessage = '❌ Collection not found. Please contact support.';
          break;
        default:
          errorMessage = '❌ Failed to list car: ${e.message ?? 'Unknown error'}';
      }

      if (mounted) {
        setState(() {
          _isListingCar = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _listCarToFirestore(),
            ),
          ),
        );
      }
    } catch (e) {
      // Handle other errors
      print('❌ Unexpected Error: $e');

      if (mounted) {
        setState(() {
          _isListingCar = false;
        });

        _showSnackBar(
          '❌ An unexpected error occurred: ${e.toString()}',
          Colors.red,
        );
      }
    }
  }

  // Show SnackBar with custom styling
  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              backgroundColor == Colors.green
                  ? Icons.check_circle
                  : Icons.error,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
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
                    icon: const Icon(Icons.menu, color: Color(0xFF1E3A5F)),
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
                    // Car Image Placeholder
                    Stack(
                      children: [
                        Container(
                          height: 180,
                          decoration: BoxDecoration(
                            color:  Colors.grey[300],
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
                                    icon:  const Icon(Icons.arrow_back_ios),
                                    color: Colors.white,
                                    onPressed:  () {
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
                                right:  8,
                                top:  0,
                                bottom:  0,
                                child:  Center(
                                  child:  IconButton(
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
                                    color: Colors. black.withOpacity(0.6),
                                    borderRadius:  BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons. location_on,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        widget.carDetails['Set Location'] ??
                                            'Tamilnadu/salem',
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
                            mainAxisAlignment:  MainAxisAlignment.center,
                            children: List.generate(
                              3,
                                  (index) => Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index == _currentImageIndex
                                      ? const Color(0xFF1E3A5F)
                                      :  Colors.white,
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
                      'Estimated price: ',
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
                        color: Colors.white. withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Car details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E3A5F),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${widget.carDetails['Brand'] ?? 'Mercedes-Benz'} ${widget.carDetails['Model'] ?? 'GLA'}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E3A5F),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${widget.carDetails['KM Driven'] ?? '2,6,600'} KM  •  ${widget.carDetails['Fuel Type'] ?? 'Diesel'}  •  ${widget.carDetails['Set Location'] ?? 'Tamil Nadu'}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF1E3A5F),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Transmission',
                                      style: TextStyle(
                                        fontSize:  12,
                                        color: Color(0xFF666666),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.carDetails['Transmission Type'] ??
                                          'Auto',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight:  FontWeight.w600,
                                        color: Color(0xFF1E3A5F),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Engine Capacity',
                                      style:  TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF666666),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '1498 cc',
                                      style: TextStyle(
                                        fontSize:  14,
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
                            onPressed: _isListingCar
                                ? null
                                :  () {
                              print(
                                'Navigating to sell_inspection with data: $updatedCarDetails',
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SellInspectionScreen(
                                        carDetails: Map<String, dynamic>.from(
                                          updatedCarDetails,
                                        ),
                                      ),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(
                                color:  _isListingCar
                                    ? Colors.grey
                                    : const Color(0xFF1E3A5F),
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Text(
                              'Free Inspection',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _isListingCar
                                    ?  Colors.grey
                                    :  const Color(0xFF1E3A5F),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isListingCar ?  null : _listCarToFirestore,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E3A5F),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              disabledBackgroundColor:
                              const Color(0xFF1E3A5F).withOpacity(0.5),
                            ),
                            child: _isListingCar
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : const Text(
                              'List My Car',
                              style:  TextStyle(
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

  Future<void> seedDummyCars() async {
    final List<Map<String, dynamic>> dummyCars = [
      {
        'Brand': 'Toyota',
        'Model': 'Corolla',
        'Variant': 'Altis Grande',
        'Year': 2021,
        'Transmission Type': 'CVT',
        'Fuel Type': 'Petrol',
        'KM Driven': 15000,
        'Set Location':  'Islamabad',
        'Estimated Price': 'RS:  5,500,000',
        'Screen':  'Car Details Screen',
        'Auto Detect': false,
        'Car Name': 'Toyota Corolla Altis',
        'Engine Capacity': 1800,
        'Final Estimated Price': 'RS: 5,200,000',
        'seller_uid': 'User123Toyota',
        'seller_name':  'Ahmed Khan',
        'seller_email':  'ahmed.k@example.com',
        'listed_at': FieldValue.serverTimestamp(),
        'status': 'active'
      },
      {
        'Brand': 'Honda',
        'Model': 'Civic',
        'Variant': 'RS Turbo',
        'Year': 2022,
        'Transmission Type':  'CVT',
        'Fuel Type': 'Petrol',
        'KM Driven': 8500,
        'Set Location': 'Lahore',
        'Estimated Price': 'RS: 8,200,000',
        'Screen':  'Car Details Screen',
        'Auto Detect': true,
        'Car Name': 'Honda Civic RS',
        'Engine Capacity': 1500,
        'Final Estimated Price': 'RS: 8,000,000',
        'seller_uid': 'UserCivicFan',
        'seller_name':  'Sarah J',
        'seller_email': 'sarah.j@example.com',
        'listed_at':  FieldValue.serverTimestamp(),
        'status': 'active'
      },
      {
        'Brand': 'Audi',
        'Model': 'A4',
        'Variant': 'S Line',
        'Year': 2018,
        'Transmission Type':  'S-Tronic',
        'Fuel Type': 'Petrol',
        'KM Driven': 45000,
        'Set Location':  'Karachi',
        'Estimated Price': 'RS: 11,500,000',
        'Screen':  'Car Details Screen',
        'Auto Detect': false,
        'Car Name': 'Audi A4 TFSI',
        'Engine Capacity': 1400,
        'Final Estimated Price': 'RS: 11,000,000',
        'seller_uid': 'AudiLover99',
        'seller_name':  'Bilal Sheikh',
        'seller_email':  'bilal.s@example.com',
        'listed_at': FieldValue.serverTimestamp(),
        'status': 'pending'
      },
      {
        'Brand': 'Suzuki',
        'Model': 'Swift',
        'Variant': 'GLX CVT',
        'Year': 2023,
        'Transmission Type':  'Automatic',
        'Fuel Type':  'Petrol',
        'KM Driven': 2000,
        'Set Location':  'Rawalpindi',
        'Estimated Price': 'RS: 4,200,000',
        'Screen':  'Car Details Screen',
        'Auto Detect': false,
        'Car Name': 'Suzuki Swift GLX',
        'Engine Capacity': 1200,
        'Final Estimated Price': 'RS: 4,150,000',
        'seller_uid': 'SwiftUser01',
        'seller_name':  'Usman Ali',
        'seller_email':  'usman.ali@example.com',
        'listed_at': FieldValue.serverTimestamp(),
        'status': 'active'
      },
      {
        'Brand': 'Kia',
        'Model': 'Sportage',
        'Variant':  'AWD',
        'Year': 2020,
        'Transmission Type':  'Automatic',
        'Fuel Type': 'Petrol',
        'KM Driven': 35000,
        'Set Location':  'Multan',
        'Estimated Price': 'RS: 7,500,000',
        'Screen': 'Car Details Screen',
        'Auto Detect': false,
        'Car Name': 'Kia Sportage AWD',
        'Engine Capacity': 2000,
        'Final Estimated Price': 'RS: 7,200,000',
        'seller_uid': 'KiaOwner55',
        'seller_name':  'Fahad Mustafa',
        'seller_email': 'fahad.m@example.com',
        'listed_at': FieldValue. serverTimestamp(),
        'status': 'sold'
      },
      {
        'Brand': 'Tesla',
        'Model': 'Model 3',
        'Variant':  'Long Range',
        'Year': 2022,
        'Transmission Type':  'Automatic',
        'Fuel Type': 'Electric',
        'KM Driven': 12000,
        'Set Location':  'Islamabad',
        'Estimated Price': 'RS: 15,000,000',
        'Screen': 'Car Details Screen',
        'Auto Detect': true,
        'Car Name': 'Tesla Model 3',
        'Engine Capacity': 0,
        'Final Estimated Price': 'RS: 14,500,000',
        'seller_uid': 'ElonFanPk',
        'seller_name':  'Hamza R',
        'seller_email':  'hamza.r@example.com',
        'listed_at': FieldValue.serverTimestamp(),
        'status': 'active'
      },
      {
        'Brand': 'Toyota',
        'Model': 'Fortuner',
        'Variant':  'Legender',
        'Year': 2023,
        'Transmission Type':  'Automatic',
        'Fuel Type': 'Diesel',
        'KM Driven': 5000,
        'Set Location':  'Peshawar',
        'Estimated Price': 'RS: 18,500,000',
        'Screen':  'Car Details Screen',
        'Auto Detect': false,
        'Car Name': 'Toyota Fortuner Legender',
        'Engine Capacity': 2800,
        'Final Estimated Price': 'RS: 18,000,000',
        'seller_uid': 'OffroadKing',
        'seller_name': 'Dawood Khan',
        'seller_email': 'dawood.k@example.com',
        'listed_at': FieldValue. serverTimestamp(),
        'status': 'active'
      },
      {
        'Brand':  'Hyundai',
        'Model': 'Sonata',
        'Variant':  '2.5 Smartstream',
        'Year': 2021,
        'Transmission Type': 'Automatic',
        'Fuel Type': 'Petrol',
        'KM Driven': 22000,
        'Set Location':  'Faisalabad',
        'Estimated Price': 'RS: 9,000,000',
        'Screen': 'Car Details Screen',
        'Auto Detect': false,
        'Car Name': 'Hyundai Sonata',
        'Engine Capacity': 2500,
        'Final Estimated Price': 'RS: 8,800,000',
        'seller_uid': 'SonataDriver',
        'seller_name':  'Zainab B',
        'seller_email':  'zainab.b@example.com',
        'listed_at': FieldValue.serverTimestamp(),
        'status': 'active'
      },
      {
        'Brand': 'Mercedes-Benz',
        'Model': 'C-Class',
        'Variant': 'C200',
        'Year': 2016,
        'Transmission Type':  'Automatic',
        'Fuel Type': 'Petrol',
        'KM Driven': 60000,
        'Set Location':  'Lahore',
        'Estimated Price': 'RS: 9,500,000',
        'Screen': 'Car Details Screen',
        'Auto Detect': false,
        'Car Name': 'Mercedes C200 AMG',
        'Engine Capacity': 2000,
        'Final Estimated Price': 'RS: 9,200,000',
        'seller_uid': 'MercLover',
        'seller_name': 'Omer Qureshi',
        'seller_email': 'omer.q@example.com',
        'listed_at': FieldValue. serverTimestamp(),
        'status': 'active'
      },
      {
        'Brand':  'Daihatsu',
        'Model':  'Mira',
        'Variant':  'X SA III',
        'Year': 2019,
        'Transmission Type':  'CVT',
        'Fuel Type': 'Petrol',
        'KM Driven': 40000,
        'Set Location':  'Karachi',
        'Estimated Price': 'RS: 2,800,000',
        'Screen': 'Car Details Screen',
        'Auto Detect': false,
        'Car Name': 'Daihatsu Mira',
        'Engine Capacity': 660,
        'Final Estimated Price': 'RS: 2,650,000',
        'seller_uid': 'SmallCarUser',
        'seller_name':  'Hina T',
        'seller_email':  'hina.t@example.com',
        'listed_at': FieldValue.serverTimestamp(),
        'status': 'active'
      },
    ];

    final FirebaseFirestore _firestore = FirebaseFirestore. instance;

    try {
      final batch = _firestore.batch();

      for (var carData in dummyCars) {
        final docRef = _firestore.collection('global').doc();
        batch.set(docRef, carData);
      }

      await batch.commit();
      print('✅ Successfully seeded ${dummyCars.length} dummy cars! ');
    } catch (e) {
      print('❌ Error seeding cars: $e');
      rethrow;
    }
  }
}