import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/services.dart';

class ChatRequestScreen extends StatelessWidget {
  const ChatRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, 
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFEAF5FF), 
        body: Column(
        children: [
          // 1. Custom Status Bar & Header Area
          Container(
            color: const Color(0xFF228B22),
            child: Column(
              children: [
                // Status Bar Spacer
                SizedBox(height: MediaQuery.of(context).padding.top),
                // Divider Line
                Container(height: 1, color: Colors.white),
                // Custom App Bar Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => context.go('/home'),
                      ),
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/avatar.png'), 
                        radius: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Mr. Moe's Kitchen",
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Last Seen: Online",
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            Text(
                              "Typing",
                              style: TextStyle(color: Colors.white, fontSize: 12, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.phone_outlined, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // 2. Main Content (Message)
          Expanded(
            child: Stack(
              children: [
                // Scrollable Content
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Hi, Good day.\nPls I'll be needing your service at apartment 37, Villa Nova Estate, Apo Gudu District, Garki Abuja",
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        const SizedBox(height: 12),
                        const Text("• Fried rice", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        const Text("• 2 chicken", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        const Text("• 1 burger", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        const Text("• 1 samosa", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            "2:00 pm",
                            style: TextStyle(color: Colors.green[800], fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Action Buttons (Fixed at Bottom)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    color: Colors.white, 
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 299,
                          height: 49,
                          child: ElevatedButton(
                            onPressed: () => context.go('/home'), 
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDDEEFF), 
                              foregroundColor: const Color(0xFF228B22), 
                              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16), 
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                            child: const Text("Decline", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // Reduced font slightly to fit
                          ),
                        ),
                        const SizedBox(height: 10), 
                        SizedBox(
                          width: 299,
                          height: 49,
                          child: ElevatedButton(
                            onPressed: () {
                               // Go to proper chat screen
                               context.push('/chat/conversation');
                            }, 
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF228B22), // Green button
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                            child: const Text("Accept", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
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
}
