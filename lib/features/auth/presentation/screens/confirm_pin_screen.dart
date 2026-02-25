import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConfirmPinScreen extends ConsumerStatefulWidget {
  const ConfirmPinScreen({super.key});

  @override
  ConsumerState<ConfirmPinScreen> createState() => _ConfirmPinScreenState();
}

class _ConfirmPinScreenState extends ConsumerState<ConfirmPinScreen> {
  final List<TextEditingController> _pinControllers = List.generate(4, (index) => TextEditingController());
    final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());


  @override
  void dispose() {
    for (var controller in _pinControllers) {
      controller.dispose();
    }
     for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _submit() {
      // Mock navigation to Login (or Reset Password screen if added later)
      context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: SvgPicture.asset(
                  'assets/images/Logo.svg', 
                  height: 100,
                ),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              SizedBox(
                height: 19, 
                child: SvgPicture.asset(
                  'assets/images/PickEA-PickIT.svg',
                  fit: BoxFit.contain, 
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Confirm Pin',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'To continue, kindly enter your emmail address', // Typo in original design 'emmail', keeping consistent or correcting? Correcting to 'email address' or keeping strictly as requested?
                // User said "kindly enter your emmail address" in request text for forgot password title context but image for confirm pin shows "To continue, kindly enter your emmail address", wait, checking image...
                // Image 3 (Confirm Pin) subtitle says: "To continue, kindly enter your emmail address". It shows an email input field in the image, but the title is Confirm Pin. 
                // Ah, the user's provided images show "Confirm Pin" screen having an Email Input field and then 4 dashes below it? That's unusual.
                // Let's look at the image again.
                // Image 3: Title "Confirm Pin", Subtitle "To continue, kindly enter your emmail address". Content: Email Address Input box. Below that: 4 dashes. Below that: "Enter the Four Digit code sent to your email".
                // Okay, so it shows the email address AGAIN (maybe read-only or editable?) and then the pin input.
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 30),

               // Email Display/Input
              Container(
                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.mail_outline, color: Color(0xFF228B22)),
                    const SizedBox(width: 12),
                    Text(
                      'E-mail address', 
                      style: TextStyle(color: const Color(0xFF228B22), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

               // Pin Input
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    width: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      controller: _pinControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: const InputDecoration(
                        counterText: "",
                        border: UnderlineInputBorder(),
                      ),
                       onChanged: (value) {
                        if (value.isNotEmpty && index < 3) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
               const SizedBox(height: 20),
               Text(
                'Enter the Four Digit code sent\nto your email',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),

              const SizedBox(height: 40),

              // Done Button
              SizedBox(
                width: 299,
                height: 49,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF228B22),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
