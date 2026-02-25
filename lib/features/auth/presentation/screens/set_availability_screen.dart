import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import '../providers/auth_controller.dart';

class SetAvailabilityScreen extends ConsumerStatefulWidget {
  const SetAvailabilityScreen({super.key});

  @override
  ConsumerState<SetAvailabilityScreen> createState() => _SetAvailabilityScreenState();
}

class _SetAvailabilityScreenState extends ConsumerState<SetAvailabilityScreen> {
  // Configurable values
  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  final List<String> _times = List.generate(24, (index) {
      final hour = index % 12 == 0 ? 12 : index % 12;
      final period = index < 12 ? 'am' : 'pm';
      return '$hour:00 $period';
  });

  String? _fromDay = 'Monday';
  String? _toDay = 'Friday';
  String? _holidayAvailability = 'Yes, I\'m available';
  String? _startTime = '10:00 am';
  String? _endTime = '6:00 pm';
  String? _workers = '5 People';

  bool _agreeToTerms = false;

  void _submit() {
      if (!_agreeToTerms) {
           ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please agree to Terms and Conditions')),
            );
            return;
      }
      // Navigate to Approved Screen
      context.push('/application-approved');
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF228B22),
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // 1. Green Status Bar Background
            Container(
              color: const Color(0xFF228B22),
              height: MediaQuery.of(context).padding.top,
            ),
            // 2. White App Bar with Shadow
            Container(
              height: kToolbarHeight,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x40000000), // #00000040
                    offset: Offset(0, 5),
                    blurRadius: 200,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                children: [
                   // Back Button
                   const SizedBox(width: 8),
                   IconButton(
                     icon: const Icon(Icons.arrow_back, color: Colors.black),
                     onPressed: () {
                         if (context.canPop()) {
                             context.pop();
                         }
                     },
                   ),
                   // Title
                   const Expanded(
                     child: Text(
                       'Set Availability',
                       textAlign: TextAlign.center,
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 18,
                         color: Colors.black,
                       ),
                     ),
                   ),
                   // Skip Button
                   TextButton(
                     onPressed: () => context.push('/home'),
                     child: const Text('Skip', style: TextStyle(color: Color(0xFF228B22), fontWeight: FontWeight.bold)),
                   ),
                   const SizedBox(width: 8),
                ],
              ),
            ),
            // 3. Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: const Color(0xFF228B22), // Green background container
                            borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                _buildDropdownSection('From', _fromDay, _days, (val) => setState(() => _fromDay = val)),
                                const SizedBox(height: 12),
                                
                                _buildDropdownSection('To', _toDay, _days, (val) => setState(() => _toDay = val)),
                                const SizedBox(height: 12),
                                
                                _buildDropdownSection('Available during Holidays', _holidayAvailability, ['Yes, I\'m available', 'No'], (val) => setState(() => _holidayAvailability = val), isBoldValue: true),
                                const SizedBox(height: 12),

                                Row(
                                    children: [
                                        Expanded(child: _buildDropdownSection('Time Start', _startTime, _times, (val) => setState(() => _startTime = val))),
                                        const SizedBox(width: 12),
                                        Expanded(child: _buildDropdownSection('Time End', _endTime, _times, (val) => setState(() => _endTime = val))),
                                    ],
                                ),
                                const SizedBox(height: 12),
                                
                                _buildDropdownSection('Total Number of Workers', _workers, ['1-5 People', '5 People', '10 People', '10+ People'], (val) => setState(() => _workers = val), isBoldValue: true),
                                const SizedBox(height: 24),
                            ],
                        ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                        children: [
                            Checkbox(
                                value: _agreeToTerms,
                                activeColor: const Color(0xFF228B22),
                                onChanged: (val) => setState(() => _agreeToTerms = val ?? false),
                            ),
                            Expanded(
                                child: RichText(
                                    text: const TextSpan(
                                        style: TextStyle(color: Colors.black),
                                        children: [
                                            TextSpan(text: 'I understand and agree with the '),
                                            TextSpan(text: 'Terms', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF228B22))),
                                            TextSpan(text: ' and '),
                                            TextSpan(text: 'Conditions', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF228B22))),
                                        ]
                                    ),
                                ),
                            ),
                        ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                         width: double.infinity,
                         height: 50,
                         child: ElevatedButton(
                             onPressed: _submit,
                             style: ElevatedButton.styleFrom(
                                 backgroundColor: const Color(0xFF228B22),
                                 foregroundColor: Colors.white,
                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                             ),
                             child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                         ),
                    ),
                    const SizedBox(height: 24), // Add some bottom padding
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownSection(
      String label, 
      String? value, 
      List<String> items, 
      Function(String?) onChanged,
      {bool isBoldValue = false}
  ) {
      return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                          value: value,
                          isExpanded: true,
                          isDense: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: items.map((String item) {
                              return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                      item,
                                      style: isBoldValue && item == value ? const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF228B22)) : const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                              );
                          }).toList(),
                          onChanged: onChanged,
                      ),
                  ),
              ],
          ),
      );
  }
}
