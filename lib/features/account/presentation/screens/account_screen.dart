import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../auth/presentation/providers/user_provider.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userStreamProvider);
    final user = userAsync.value;

    final storeName = user?.firstName ?? 'Store name';
    final storeAddress = user?.email ?? 'Store full address';
    final profileImageUrl = user?.profileImageUrl;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF228B22),
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Green status bar
            Container(
              color: const Color(0xFF228B22),
              height: MediaQuery.of(context).padding.top,
            ),
            // App bar
            Container(
              height: kToolbarHeight,
              decoration: const BoxDecoration(
                color: Color(0xFFE5F2FF),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x40000000),
                    offset: Offset(0, 4),
                    blurRadius: 200,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile card with green curve
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xB2F5F5F5),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              // Avatar
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey[300],
                                backgroundImage: profileImageUrl != null && profileImageUrl.isNotEmpty
                                    ? NetworkImage(profileImageUrl)
                                    : const AssetImage('assets/images/man.png') as ImageProvider,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                storeName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                storeAddress,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        // Rating badge at extreme top-right
                        Positioned(
                          right: 20,
                          top: 20,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                '4.0',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFF228B22),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.star, color: const Color(0xFF228B22), size: 24),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Menu items
                    const SizedBox(height: 8),
                    _buildSvgMenuItem(
                      svgPath: 'assets/images/profile.svg',
                      label: 'Profile',
                      onTap: () => context.push('/profile-detail'),
                    ),
                    _buildSvgMenuItem(
                      svgPath: 'assets/images/menu.svg',
                      label: 'Menu',
                      onTap: () => context.push('/menu'),
                    ),
                    _buildSvgMenuItem(
                      svgPath: 'assets/images/history.svg',
                      label: 'Order History',
                      onTap: () => context.push('/order-history'),
                    ),
                    _buildSvgMenuItem(
                      svgPath: 'assets/images/earning.svg',
                      label: 'Earning and Payment',
                      onTap: () => context.push('/earnings-payment'),
                    ),
                    _buildSvgMenuItem(
                      svgPath: 'assets/images/device.svg',
                      label: 'Devices and Session',
                      onTap: () => context.push('/devices-sessions'),
                    ),
                    _buildSvgMenuItem(
                      svgPath: 'assets/images/review.svg',
                      label: 'Review and Ratings',
                      onTap: () => context.push('/reviews'),
                    ),
                    _buildSvgMenuItem(
                      svgPath: 'assets/images/support.svg',
                      label: 'Support',
                      onTap: () => context.push('/support'),
                    ),

                    const SizedBox(height: 24),

                    // Log out button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 45.0),
                      child: SizedBox(
                        width: 299,
                        height: 49,
                        child: ElevatedButton(
                          onPressed: () async {
                            await ref.read(authControllerProvider.notifier).signOut();
                            if (context.mounted) {
                              context.go('/login');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF228B22),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Opacity(
                                opacity: 0,
                                child: Icon(Icons.logout, size: 20),
                              ),
                              const Expanded(
                                child: Center(
                                  child: Text(
                                    'Log out',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const Icon(Icons.logout, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSvgMenuItem({
    required String svgPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: const BoxDecoration(
                color: Color(0xFFE5F2FF),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(svgPath, width: 22, height: 22),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
