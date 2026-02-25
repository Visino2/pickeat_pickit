
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/data/auth_repository.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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
                    color: Color(0x40000000), 
                    offset: Offset(0, 4),
                    blurRadius: 200,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                children: [
                   const SizedBox(width: 48), 
                   // Title
                   const Expanded(
                     child: Text(
                       'My Dashboard',
                       textAlign: TextAlign.center,
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 18,
                         color: Colors.black,
                       ),
                     ),
                   ),
                   // Notification Bell
                   Padding(
                     padding: const EdgeInsets.only(right: 16.0),
                     child: InkWell(
                        onTap: () {},
                        child: SvgPicture.asset(
                            'assets/images/bell.svg',
                            width: 24,
                            color: Colors.black,
                        ),
                     ),
                   ),
                ],
              ),
            ),
            // 3. Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    
                    // Insights Container
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF5FF), 
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                           // Card 1: Total Orders (Horizontal)
                           Container(
                               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                               decoration: BoxDecoration(
                                 color: Colors.white,
                                 borderRadius: BorderRadius.circular(12),
                               ),
                               child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                       Text('Total Orders', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600, fontSize: 15)),
                                       const Text('0', style: TextStyle(color: Color(0xFF228B22), fontWeight: FontWeight.bold, fontSize: 16)),
                                   ],
                               ),
                           ),
                           const SizedBox(height: 12),

                           // Card 2: Total Amount (Vertical)
                           _buildVerticalInsightCard('Total amount', 'N0'),
                           const SizedBox(height: 12),

                           // Card 3: Total Amount (Vertical)
                           _buildVerticalInsightCard('Total amount', 'N0'), 
                        ],
                      ),
                    ),
                     const SizedBox(height: 24),

                     const Text('Most Popular orders', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                     const SizedBox(height: 16),

                     _buildPopularOrder('Fried Rice', '54'),
                     _buildPopularOrder('Fried Rice', '54'),
                     _buildPopularOrder('Fried Rice', '54'),
                     
                     const SizedBox(height: 35),

                     const Text('Reviews', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                     const SizedBox(height: 8),
                     
                     Row(
                         crossAxisAlignment: CrossAxisAlignment.end,
                         children: [
                             const Text('4.7', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, height: 1)),
                             const SizedBox(width: 8),
                             Row(
                                 children: [
                                     // 4 full stars
                                     ...List.generate(4, (index) => const Icon(Icons.star, color: Color(0xFF228B22), size: 28)),
                                     // 1 half star
                                     const Icon(Icons.star_half, color: Color(0xFF228B22), size: 28),
                                 ],
                             ), 
                         ],
                     ),
                     const SizedBox(height: 4),
                     Text('(578 Reviews)', style: TextStyle(color: Colors.grey[600])),
                     
                     const SizedBox(height: 80), 
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Simulated user state
            bool isNewUser = false; 
            
            if (isNewUser) {
              context.push('/chat'); // Navigate to Chat Request
            } else {
              context.go('/chats'); // Navigate to existing chat list in bottom nav
            }
          },
          backgroundColor: const Color(0xFF228B22),
          shape: const CircleBorder(),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset(
              'assets/images/thread.svg',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalInsightCard(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(
              value, 
              style: const TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 18,
                  color: Color(0xFF228B22)
              )
          ),
        ],
      ),
    );
  }

  Widget _buildPopularOrder(String name, String count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0), 
      child: Column(
        children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0F0F0),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('Most recent', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                        ],
                      ),
                    ),
                    Text(count, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF228B22))),
                  ],
                ),
            ),
            
            const Divider(indent: 66, height: 1), 
            const SizedBox(height: 12),
        ],
      ),
    );
  }
}
