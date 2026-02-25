import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/auth/presentation/screens/otp_screen.dart';
import '../features/auth/presentation/screens/create_profile_screen.dart';
import '../features/auth/presentation/screens/setup_location_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/auth/presentation/screens/sign_up_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/verify_email_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/confirm_pin_screen.dart';
import '../features/auth/presentation/screens/store_info_screen.dart';
import '../features/auth/presentation/screens/set_availability_screen.dart';
import '../features/auth/presentation/screens/application_approved_screen.dart';
import '../features/orders/presentation/screens/orders_screen.dart';

import '../features/auth/presentation/providers/user_provider.dart';
import '../features/auth/data/user_model.dart';

import '../features/chat/presentation/screens/chat_request_screen.dart';
import '../features/chat/presentation/screens/chat_screen.dart';
import '../features/chat/presentation/screens/chat_list_screen.dart';
import '../features/account/presentation/screens/account_screen.dart';
import '../features/account/presentation/screens/profile_detail_screen.dart';
import '../features/account/presentation/screens/order_history_screen.dart';
import '../features/account/presentation/screens/support_screen.dart';
import '../features/account/presentation/screens/devices_sessions_screen.dart';
import '../features/account/presentation/screens/menu_screen.dart';
import '../features/account/presentation/screens/add_menu_item_screen.dart';
import '../features/account/presentation/screens/earnings_payment_screen.dart';
import '../features/account/presentation/screens/earnings_orders_screen.dart';
import '../features/account/presentation/screens/reviews_screen.dart';


import '../core/router_notifier.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/onboarding',
    refreshListenable: notifier,
    routes: [
      // ... existing routes ...
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
           final verificationId = state.extra as String;
           return OtpScreen(verificationId: verificationId);
        },
      ),
      GoRoute(
        path: '/create-profile',
        builder: (context, state) => const CreateProfileScreen(),
      ),
      GoRoute(
        path: '/location',
        builder: (context, state) => const SetupLocationScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/verify-email',
        builder: (context, state) {
            final email = state.extra as String?;
            return VerifyEmailScreen(email: email);
        },
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/confirm-pin',
        builder: (context, state) => const ConfirmPinScreen(),
      ),
      GoRoute(
        path: '/store-info',
        builder: (context, state) => const StoreInfoScreen(),
      ),
      GoRoute(
        path: '/set-availability',
        builder: (context, state) => const SetAvailabilityScreen(),
      ),
      GoRoute(
        path: '/application-approved',
        builder: (context, state) => const ApplicationApprovedScreen(),
      ),
      GoRoute(
        path: '/profile-detail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ProfileDetailScreen(),
      ),
      GoRoute(
        path: '/order-history',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OrderHistoryScreen(),
      ),
      GoRoute(
        path: '/support',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SupportScreen(),
      ),
      GoRoute(
        path: '/devices-sessions',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const DevicesSessionsScreen(),
      ),
      GoRoute(
        path: '/menu',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const MenuScreen(),
      ),
      GoRoute(
        path: '/add-menu-item',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AddMenuItemScreen(),
      ),
      GoRoute(
        path: '/earnings-payment',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EarningsPaymentScreen(),
      ),
      GoRoute(
        path: '/earnings-orders',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EarningsOrdersScreen(),
      ),
      GoRoute(
        path: '/reviews',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ReviewsScreen(),
      ),

      // Chat Routes (Full Screen - Outside Shell)
      GoRoute(
        path: '/chat',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ChatRequestScreen(),
        routes: [
           GoRoute(
             path: 'conversation',
             parentNavigatorKey: _rootNavigatorKey,
             builder: (context, state) {
               final extra = state.extra as Map<String, dynamic>? ?? {};
               return ChatScreen(
                 contactName: extra['name'] ?? 'Chat',
                 contactAvatar: extra['avatar'] ?? 'assets/images/avatar.png',
               );
             },
           ),
        ],
      ),
      
      // ShellRoute for Bottom Navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithBottomNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
            parentNavigatorKey: _shellNavigatorKey,
          ),
          GoRoute(
            path: '/orders',
            builder: (context, state) => const OrdersScreen(),
            parentNavigatorKey: _shellNavigatorKey,
          ),
          GoRoute(
            path: '/chats',
            builder: (context, state) => const ChatListScreen(),
            parentNavigatorKey: _shellNavigatorKey,
          ),
          GoRoute(
            path: '/account',
            builder: (context, state) => const AccountScreen(),
             parentNavigatorKey: _shellNavigatorKey,
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final authRepository = ref.read(authRepositoryProvider);
      final userAsync = ref.read(userStreamProvider);

      final isLoggedIn = authRepository.currentUser != null;
      final path = state.uri.toString();
      final isPublicRoute = path == '/otp' || 
                            path == '/onboarding' || 
                            path == '/signup' || 
                            path == '/login' || 
                            path == '/verify-email' || 
                            path == '/forgot-password' || 
                            path == '/confirm-pin';

      if (!isLoggedIn) {
        if (isPublicRoute) return null;
        return '/onboarding';
      }

      // Logged in Logic
      // Wait for user data to load if possible, or assume incomplete if null
      if (userAsync.isLoading) return null;

      final userModel = userAsync.value;
      final isProfileCompleted = userModel?.isProfileCompleted ?? false;

      if (!isProfileCompleted) {
         // Allow access to profile creation flow
         final onboardingRoutes = [
             '/create-profile', 
             '/store-info', 
             '/set-availability', 
             '/application-approved',
             '/location'
         ];
         
         if (onboardingRoutes.contains(path)) return null;
         
         // Redirect to start of profile creation
         return '/create-profile';
      }

      // Profile Completed
      // Redirect auth/onboarding routes to home
      if (isPublicRoute || path == '/create-profile' || path == '/store-info' || path == '/set-availability' || path == '/application-approved') {
          return '/home';
      }

      return null;
    },
  );
});

class ScaffoldWithBottomNavBar extends StatefulWidget {
  final Widget child;
  const ScaffoldWithBottomNavBar({super.key, required this.child});

  @override
  State<ScaffoldWithBottomNavBar> createState() => _ScaffoldWithBottomNavBarState();
}

class _ScaffoldWithBottomNavBarState extends State<ScaffoldWithBottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index, BuildContext context) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/orders');
        break;
      case 2:
        context.go('/chats');
        break;
      case 3:
         context.go('/account');
        break;
    }
  }
  
  // Helper to determine index from location for initial state or back nav
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/orders')) return 1;
    if (location.startsWith('/chats')) return 2;
    if (location.startsWith('/account')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => _onItemTapped(index, context),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: const Color(0xFF228B22),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
              icon: _buildAnimatedIcon('assets/images/home.svg', selectedIndex == 0), 
              label: 'Home'
          ),
          BottomNavigationBarItem(
              icon: _buildAnimatedIcon('assets/images/order.svg', selectedIndex == 1), 
              label: 'Orders'
          ),
          BottomNavigationBarItem(
              icon: _buildAnimatedIcon('assets/images/chat.svg', selectedIndex == 2), 
              label: 'Chat'
          ),
          BottomNavigationBarItem(
              icon: _buildAnimatedIcon('assets/images/account.svg', selectedIndex == 3), 
              label: 'Account'
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedIcon(String assetPath, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: EdgeInsets.only(
        bottom: isSelected ? 8.0 : 4.0, // Slight bounce/lift effect when selected
        top: isSelected ? 0.0 : 4.0,
      ),
      child: AnimatedScale(
        scale: isSelected ? 1.15 : 1.0, // Scale up when selected
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: SvgPicture.asset(assetPath), // No color filter, retain original colors
      ),
    );
  }
}
