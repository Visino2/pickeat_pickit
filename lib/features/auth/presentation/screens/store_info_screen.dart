import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import '../providers/auth_controller.dart';

class StoreInfoScreen extends ConsumerStatefulWidget {
  const StoreInfoScreen({super.key});

  @override
  ConsumerState<StoreInfoScreen> createState() => _StoreInfoScreenState();
}

class _StoreInfoScreenState extends ConsumerState<StoreInfoScreen> {
  final _descriptionController = TextEditingController();
  final _additionalInfoController = TextEditingController();
  final _descriptionFocusNode = FocusNode();
  final _additionalInfoFocusNode = FocusNode();

  @override
  void dispose() {
    _descriptionController.dispose();
    _additionalInfoController.dispose();
    _descriptionFocusNode.dispose();
    _additionalInfoFocusNode.dispose();
    super.dispose();
  }

  void _submit() {
      // Navigate to Set Availability
      context.push('/set-availability');
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
                    offset: Offset(0, 4),
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
                     onPressed: () => context.pop(),
                   ),
                   // Title
                   const Expanded(
                     child: Text(
                       'Create Profile',
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                     // Store Image Upload
                     Container(
                         padding: const EdgeInsets.all(20),
                         decoration: BoxDecoration(
                             color: Colors.white,
                             borderRadius: BorderRadius.circular(12),
                             boxShadow: [
                                 BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5)
                             ]
                         ),
                         child: Row(
                             children: [
                                 Container(
                                     width: 100,
                                     height: 100,
                                     padding: const EdgeInsets.all(8),
                                     decoration: const BoxDecoration(
                                         color: Color(0xFFE5F2FF), // Updated color
                                         shape: BoxShape.circle,
                                     ),
                                     child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
                                             SvgPicture.asset('assets/images/camera.svg', width: 50, height: 50),
                                             const SizedBox(height: 4),
                                             const Text(
                                                 'Upload\nStore Image',
                                                 textAlign: TextAlign.center,
                                                 style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black, height: 1.1),
                                             ),
                                         ],
                                     ),
                                 ),
                                 const SizedBox(width: 20),
                                 Expanded(
                                     child: Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                             const Text('Mr. Moe\'s Kitchen', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                             const SizedBox(height: 5),
                                             const Text('Restaurant', style: TextStyle(color: Color(0xFF228B22), fontWeight: FontWeight.w600)),
                                             const SizedBox(height: 5),
                                             Text('Creativeomotayo@gmail.com', style: TextStyle(fontSize: 12, color: Colors.grey[800])),
                                             const Text('+234 906 3287 855', style: TextStyle(fontSize: 12, color: Color(0xFF228B22), fontWeight: FontWeight.bold)),
                                         ],
                                     ),
                                 ),
                             ],
                         ),
                     ),
                     const SizedBox(height: 24),

                     // Cover Photo Upload
                     Container(
                         padding: const EdgeInsets.all(20),
                         decoration: BoxDecoration(
                             color: Colors.white,
                             borderRadius: BorderRadius.circular(12),
                             boxShadow: [
                                 BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5)
                             ]
                         ),
                         child: Row(
                             children: [
                                 Container(
                                     width: 100,
                                     height: 100,
                                     padding: const EdgeInsets.all(8),
                                     decoration: const BoxDecoration(
                                         color: Color(0xFFE5F2FF), 
                                         shape: BoxShape.circle,
                                     ),
                                     child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
                                             SvgPicture.asset('assets/images/camera.svg', width: 50, height: 50),
                                             const SizedBox(height: 4),
                                             const Text(
                                                 'Upload\nCover Photo',
                                                 textAlign: TextAlign.center,
                                                 style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black, height: 1.1),
                                             ),
                                         ],
                                     ),
                                 ),
                                 const SizedBox(width: 20),
                                 Expanded(
                                     child: Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                             const Text('Upload store cover photo', style: TextStyle(color: Color(0xFF228B22), fontWeight: FontWeight.bold)),
                                             const SizedBox(height: 8),
                                             Text('Allowed formats', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                             Text('• Jpeg', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                             Text('• Png', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                             const SizedBox(height: 8),
                                             Text('Less than 1mb', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                         ],
                                     ),
                                 ),
                             ],
                         ),
                     ),
                     const SizedBox(height: 24),

                     // Business Description
                     Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                 BoxShadow(
                                   color: Color(0x40000000), // #00000040
                                   offset: Offset(0, 4),
                                   blurRadius: 200,
                                   spreadRadius: 0,
                                 ),
                              ],
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                   // Label and Divider inside
                                   const Text('Business Description', style: TextStyle(color: Color(0xFF228B22), fontWeight: FontWeight.bold, fontSize: 16)),
                                   const Divider(color: Color(0xFF228B22), thickness: 1),
                                   const SizedBox(height: 8),

                                   // Clickable Area for Input
                                   GestureDetector(
                                      onTap: () {
                                          // Focus or navigate logic if needed. For now simple text field visual.
                                          // Or ensure the TextField below is usable.
                                      },
                                      child: TextField(
                                          controller: _descriptionController,
                                          maxLines: 5,
                                          decoration: InputDecoration(
                                              hintText: 'Kindly Provide details below',
                                              hintStyle: TextStyle(color: Colors.grey[500]),
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.zero,
                                          ),
                                      ),
                                   ),
                              ],
                          ),
                     ),
                     const SizedBox(height: 24),

                     // Additional Info
                     Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                 BoxShadow(
                                   color: Color(0x40000000), // #00000040
                                   offset: Offset(0, 4),
                                   blurRadius: 200,
                                   spreadRadius: 0,
                                 ),
                              ],
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                   const Text('Additional Info', style: TextStyle(color: Color(0xFF228B22), fontWeight: FontWeight.bold, fontSize: 16)),
                                   const Divider(color: Color(0xFF228B22), thickness: 1),
                                   const SizedBox(height: 8),
                                   TextField(
                                       controller: _additionalInfoController,
                                       maxLines: 4,
                                       decoration: InputDecoration(
                                           hintText: 'Please provide additional details if need be',
                                           hintStyle: TextStyle(color: Colors.grey[500]),
                                           border: InputBorder.none,
                                           contentPadding: EdgeInsets.zero,
                                       ),
                                   ),
                              ],
                          ),
                     ),
                     const SizedBox(height: 40),

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
                             child: const Text('Continue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                         ),
                     ),
                     const SizedBox(height: 24),
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
