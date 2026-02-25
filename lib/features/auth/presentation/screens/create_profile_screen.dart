import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_controller.dart';

class CreateProfileScreen extends ConsumerStatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  ConsumerState<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends ConsumerState<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _businessNameController = TextEditingController();
  final _addressObjController = TextEditingController(); 
  final _fullNameController = TextEditingController();
  final _businessMailController = TextEditingController();
  final _businessPhoneController = TextEditingController(); 
  final _businessAddressController = TextEditingController();
  final _membershipIdController = TextEditingController();

  // Dropdown Values
  String? _yearsOfExperience;
  String? _countryRegion = 'Nigeria'; 
  String? _profession;
  String? _vendorType;
  String? _workAlone = 'YES'; 

  bool _agreeToTerms = false;

  @override
  void dispose() {
    _businessNameController.dispose();
    _addressObjController.dispose();
    _fullNameController.dispose();
    _businessMailController.dispose();
    _businessPhoneController.dispose();
    _businessAddressController.dispose();
    _membershipIdController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
        if (!_agreeToTerms) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please agree to Terms and Conditions')),
            );
            return;
        }

      // Proceed to Store Info
      context.push('/store-info'); 
      // Note: Actual data saving would happen here or be passed along
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

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
                   // For CreateProfile, back button usually goes back? Or maybe implicit? 
                   // Using go_router canPop check or just keep implicit if I used AppBar. 
                   // Here I must add it manually.
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                         // Keep existing form content...
                         // Warning 1
                         _buildWarningBox(context, 'Please Kindly provide the correct info below'),
                         const SizedBox(height: 20),
          
                         _buildTextField(controller: _businessNameController, label: 'Business Name*', hint: 'Business Name*'),
                         const SizedBox(height: 16),
                         
                         _buildTextField(controller: _addressObjController, label: 'How do you want to address?', hint: 'How do you want to address?'),
                         const SizedBox(height: 16),
                         
                         _buildTextField(controller: _fullNameController, label: 'Full Name*', hint: 'Full Name*'),
                         const SizedBox(height: 16),
                         
                         _buildDropdown(
                             value: _yearsOfExperience,
                             hint: 'Years of Experience',
                             items: ['0-1 year', '1-3 years', '3-5 years', '5+ years'],
                             onChanged: (val) => setState(() => _yearsOfExperience = val),
                         ),
                         const SizedBox(height: 24),
          
                         // Warning 2
                         _buildWarningBox(context, 'All necessary info will be sent to business contact provided below'),
                          const SizedBox(height: 20),
          
                         _buildTextField(controller: _businessMailController, label: 'Business mail*', hint: 'Business mail*', keyboardType: TextInputType.emailAddress),
                         const SizedBox(height: 16),
          
                         // Country Region
                         Container(
                             height: 48, // Consistent height
                             padding: const EdgeInsets.symmetric(horizontal: 12),
                             decoration: BoxDecoration(
                                 border: Border.all(color: Colors.grey.shade400),
                                 borderRadius: BorderRadius.circular(8),
                             ),
                             child: Row(
                                 children: [
                                     Text('Select country region', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                     const SizedBox(width: 4),
                                     const Text('(Nigeria)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF228B22), fontSize: 13)),
                                 ],
                             ),
                         ),
                         const SizedBox(height: 16),
          
                         // Phone Number with Prefix
                         Row(
                             children: [
                                 Container(
                                     width: 70,
                                     height: 48,
                                     decoration: BoxDecoration(
                                         border: Border.all(color: Colors.grey.shade400),
                                         borderRadius: BorderRadius.circular(8),
                                     ),
                                     alignment: Alignment.center,
                                     child: const Text('+234', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                 ),
                                 const SizedBox(width: 8),
                                 Expanded(
                                     child: _buildTextField(
                                         controller: _businessPhoneController, 
                                         label: 'Business Phone number*', 
                                         hint: 'Business Phone number*', 
                                         keyboardType: TextInputType.phone,
                                         suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                                     ),
                                 ),
                             ],
                         ),
                         const SizedBox(height: 16),
          
                          _buildTextField(controller: _businessAddressController, label: 'Business address*', hint: 'Business address*'),
                          const SizedBox(height: 24),
          
                          // Warning 3
                          _buildWarningBox(context, 'All details you provided must be true, accurate and non-misleading. In the event you provided wrong information, you shall be held liable for such misconduct'),
                          const SizedBox(height: 20),
          
                          _buildDropdown(
                             value: _profession,
                             hint: 'Profession*',
                             items: ['Chef', 'Caterer', 'Vendor'],
                             onChanged: (val) => setState(() => _profession = val),
                         ),
                         const SizedBox(height: 16),
          
                         _buildDropdown(
                             value: _vendorType,
                             hint: 'Vendor type*',
                             items: ['Individual', 'Company'],
                             onChanged: (val) => setState(() => _vendorType = val),
                         ),
                         const SizedBox(height: 16),
          
                         _buildDropdown(
                             value: _workAlone,
                             hint: 'You work alone?',
                             items: ['YES', 'NO'],
                             onChanged: (val) => setState(() => _workAlone = val),
                             isBoldValue: true,
                         ),
                         const SizedBox(height: 24),
          
                         // Warning 4
                         _buildWarningBox(context, 'In order to make points and benefits from PickEat PickIt please enter your membership ID'),
                         const SizedBox(height: 20),
                         
                         _buildTextField(controller: _membershipIdController, label: 'Membership ID/Promo Code', hint: 'Membership ID/Promo Code'),
                         const SizedBox(height: 16),
          
                         // Terms Checkbox
                         Row(
                             crossAxisAlignment: CrossAxisAlignment.start, // Align to top for multiline text if needed
                             children: [
                                 SizedBox(
                                     width: 24, 
                                     height: 24,
                                     child: Checkbox(
                                         value: _agreeToTerms,
                                         activeColor: const Color(0xFF228B22),
                                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), // Slightly rounded checkbox
                                         side: BorderSide(color: Colors.grey.shade400, width: 1.5),
                                         onChanged: (val) => setState(() => _agreeToTerms = val ?? false),
                                     ),
                                 ),
                                 const SizedBox(width: 8),
                                 Expanded(
                                     child: const Text(
                                         'I understand and agree with the Terms and Conditions',
                                         style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
                                     ),
                                 ),
                             ],
                         ),
                         const SizedBox(height: 24), // More space before button
          
                         Center(
                             child: SizedBox(
                                  width: double.infinity, 
                                  height: 50,
                                  child: ElevatedButton(
                                      onPressed: state.isLoading ? null : _submit,
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF228B22),
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      child: state.isLoading
                                          ? const CircularProgressIndicator(color: Colors.white)
                                          : const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  ),
                             ),
                         ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller, 
    required String label, 
    required String hint, 
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
      return TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 13, color: Colors.black),
          decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16), // Approx 45-48px height
              isDense: true,
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF228B22), width: 1.5),
              ),
          ),
          validator: (value) {
              if (label.contains('*') && (value == null || value.isEmpty)) {
                  return 'Required';
              }
              return null;
          },
      );
  }

  Widget _buildDropdown({
      required String? value, 
      required String hint, 
      required List<String> items, 
      required Function(String?) onChanged,
      bool isBoldValue = false,
  }) {
      return Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
           decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
           ),
           child: DropdownButtonHideUnderline(
               child: DropdownButton<String>(
                   value: value,
                   hint: Text(hint, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                   isExpanded: true,
                   icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                   items: items.map((String item) {
                       return DropdownMenuItem<String>(
                           value: item,
                           child: Text(
                               item, 
                               style: isBoldValue && item == value ? const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF228B22), fontSize: 13) : const TextStyle(fontSize: 13)
                           ),
                       );
                   }).toList(),
                   onChanged: onChanged,
               ),
           ),
      );
  }



  Widget _buildWarningBox(BuildContext context, String text) {
      return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD), // Light blue background like generic info/warning
              borderRadius: BorderRadius.circular(8), 
          ),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  const Icon(Icons.error, color: Colors.amber, size: 24), // Using error icon with amber color usually looks like the alert
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text(
                          text,
                          style: const TextStyle(color: Color(0xFF228B22), fontSize: 13, height: 1.4, fontWeight: FontWeight.w500), 
                      ),
                  ),
              ],
          ),
      );
  }
}
