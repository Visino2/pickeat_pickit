import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Order data
    final List<Map<String, dynamic>> orders = [
      {
        'name': 'Robert Fox',
        'image': 'assets/images/potatoes.png',
        'date': 'Oct 24, 2022 at 06:00 am',
        'amount': 'N5000',
        'status': 'Completed',
        'action': 'Check Review',
      },
      {
        'name': 'Cameron Williamson',
        'image': 'assets/images/cameron.png',
        'date': 'Oct 24, 2022 at 06:00 am',
        'amount': 'N5000',
        'status': 'Pending',
        'action': 'Accept',
      },
      {
        'name': 'Wade Warren',
        'image': 'assets/images/wade.png',
        'date': 'Oct 24, 2022 at 06:00 am',
        'amount': 'N5000',
        'status': 'Cancelled',
        'action': null,
      },
      {
        'name': 'Brooklyn Simmons',
        'image': 'assets/images/brookslyn.png',
        'date': 'Oct 24, 2022 at 06:00 am',
        'amount': 'N5000',
        'status': 'Cancelled',
        'action': null,
      },
      {
        'name': 'Kathryn Murphy',
        'image': 'assets/images/murphy.png',
        'date': 'Oct 24, 2022 at 06:00 am',
        'amount': 'N5000',
        'status': 'Completed',
        'action': 'Check Review',
      },
      {
        'name': 'Eleanor Pena',
        'image': 'assets/images/pena.png',
        'date': 'Oct 24, 2022 at 06:00 am',
        'amount': 'N5000',
        'status': 'Pending',
        'action': 'Accept',
      },
    ];

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
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
            ),

            // Order History header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Order History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF228B22),
                  ),
                ),
              ),
            ),

            // Content
            Expanded(
              child: orders.isEmpty
                  ? _buildEmptyState()
                  : _buildOrderList(orders),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF5F5F5),
      child: Center(
        child: SvgPicture.asset(
          'assets/images/order-2.svg',
          width: 220,
          height: 220,
        ),
      ),
    );
  }

  Widget _buildOrderList(List<Map<String, dynamic>> orders) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: orders.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey[200],
      ),
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderItem(order);
      },
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> order) {
    final String status = order['status'];
    final String? action = order['action'];

    Color statusColor;
    switch (status) {
      case 'Completed':
        statusColor = const Color(0xFF228B22);
        break;
      case 'Pending':
        statusColor = const Color(0xFF228B22);
        break;
      case 'Cancelled':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              order['image'],
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),

          // Name, date, amount
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order['name'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  order['date'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Amount: ',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      TextSpan(
                        text: order['amount'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF228B22),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Action button + status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (action != null)
                Container(
                  width: 100,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: action == 'Check Review'
                        ? const Color(0xFF228B22)
                        : const Color(0xFFE5F2FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    action,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: action == 'Check Review'
                          ? Colors.white
                          : const Color(0xFF228B22),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                status,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
