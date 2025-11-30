import 'package:flutter/material.dart';

class SellInspectionScreen extends StatefulWidget {
  final Map<String, String> carDetails;

  const SellInspectionScreen({
    Key?  key,
    required this.carDetails,
  }) : super(key: key);

  @override
  State<SellInspectionScreen> createState() => _SellInspectionScreenState();
}

class _SellInspectionScreenState extends State<SellInspectionScreen> {
  int _currentImageIndex = 0;
  String? selectedHub;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  late Map<String, String> finalCarDetails;

  @override
  void initState() {
    super.initState();
    // Copy the received map
    finalCarDetails = Map<String, String>.from(widget.carDetails);

    print('===== FINAL CAR DETAILS IN INSPECTION SCREEN =====');
    print(finalCarDetails);
    print('==================================================');
  }

  void _prepareForFirestore() {
    // Add inspection-specific fields
    if (selectedHub != null) {
      finalCarDetails['Selected Hub'] = selectedHub! ;
    }
    if (selectedDate != null) {
      finalCarDetails['Inspection Date'] = '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}';
    }
    if (selectedTime != null) {
      finalCarDetails['Inspection Time'] = '${selectedTime!.hour}:${selectedTime!.minute. toString().padLeft(2, '0')}';
    }
    finalCarDetails['Screen'] = 'Inspection Screen - FINAL';
    finalCarDetails['Status'] = 'Ready for Firestore';

    print('===== COMPLETE MAP READY FOR FIRESTORE =====');
    finalCarDetails.forEach((key, value) {
      print('$key: $value');
    });
    print('============================================');
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
                            borderRadius: BorderRadius. circular(16),
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
                                    icon: const Icon(Icons. arrow_back_ios),
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
                                    color: Colors. black.withOpacity(0.6),
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
                                        widget.carDetails['Set Location'] ??  'Tamilnadu/salem',
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
                            children: List. generate(
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
                      'RS: 25,000,00',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A5F),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Choose Hub Dropdown
                    _buildDropdownField(
                      'Choose hub',
                      selectedHub,
                      ['Hub 1', 'Hub 2', 'Hub 3'],
                          (value) {
                        setState(() {
                          selectedHub = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Select Date
                    _buildDateTimePicker(
                      'Select Date',
                      selectedDate != null
                          ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                          : null,
                      Icons.calendar_today,
                          () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime. now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() {
                            selectedDate = date;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    // Select Time
                    _buildDateTimePicker(
                      'Select Time',
                      selectedTime != null
                          ? '${selectedTime!.hour}:${selectedTime!.minute.toString(). padLeft(2, '0')}'
                          : null,
                      Icons.access_time,
                          () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          setState(() {
                            selectedTime = time;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    // Book a Free Inspection Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _prepareForFirestore();

                          // Show success dialog with all data
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('✅ Success!'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Complete car listing data:',
                                      style: TextStyle(fontWeight: FontWeight. bold),
                                    ),
                                    const SizedBox(height: 10),
                                    ... finalCarDetails.entries.map(
                                          (entry) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 2),
                                        child: Text('${entry.key}: ${entry. value}'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator. pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
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
                          'Book a Free Inspection',
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(
      String label,
      String? value,
      List<String> items,
      Function(String?) onChanged,
      ) {
    return Container(
      padding: const EdgeInsets. symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF1E3A5F),
          width: 2,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          icon: const Icon(
            Icons. keyboard_arrow_down,
            color: Color(0xFF1E3A5F),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDateTimePicker(
      String label,
      String? value,
      IconData icon,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF1E3A5F),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value ?? label,
              style: TextStyle(
                fontSize: 14,
                color: value != null ? const Color(0xFF1E3A5F) : const Color(0xFF666666),
                fontWeight: value != null ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            Icon(
              icon,
              color: const Color(0xFF1E3A5F),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}