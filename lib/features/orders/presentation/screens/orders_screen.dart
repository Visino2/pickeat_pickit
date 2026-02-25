import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';


class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _selectedTabIndex = 0; // 0: Pending, 1: Confirmed, 2: Cancelled

  final List<Map<String, dynamic>> _mockOrders = [
    {
      'name': 'Samuel Omotayo .K',
      'location': 'Vila Nova Estate, New Apo',
      'time': 'Tue 21 Oct. - 4:00PM',
      'status': 'Pending',
      'image': 'assets/images/fruit-salad.png', 
    },
    {
      'name': 'Samuel Omotayo .K',
      'location': 'Vila Nova Estate, New Apo',
      'time': 'Tue 21 Oct. - 4:00PM',
      'status': 'Pending',
      'image': 'assets/images/rice.png',
    },
     {
      'name': 'Samuel Omotayo .K',
      'location': 'Vila Nova Estate, New Apo',
      'time': 'Tue 21 Oct. - 4:00PM',
      'status': 'Pending',
      'image': 'assets/images/fruit-salad.png',
    },
    {
      'name': 'Samuel Omotayo .K',
      'location': 'Vila Nova Estate, New Apo',
      'time': 'Tue 21 Oct. - 4:00PM',
      'status': 'Confirmed',
      'isReady': false, 
      'image': 'assets/images/suya.png',
    },
    {
      'name': 'Samuel Omotayo .K',
      'location': 'Vila Nova Estate, New Apo',
      'time': 'Tue 21 Oct. - 4:00PM',
      'status': 'Confirmed',
      'isReady': true, 
      'image': 'assets/images/woman.png',
    },
    {
      'name': 'Samuel Omotayo .K',
      'location': 'Vila Nova Estate, New Apo',
      'time': 'Tue 21 Oct. - 4:00PM',
      'status': 'Cancelled',
      'image': 'assets/images/grains.png',
    },
    {
      'name': 'Samuel Omotayo .K',
      'location': 'Vila Nova Estate, New Apo',
      'time': 'Tue 21 Oct. - 4:00PM',
      'status': 'Cancelled',
      'image': 'assets/images/suya-onions.png',
    },
    {
      'name': 'Samuel Omotayo .K',
      'location': 'Vila Nova Estate, New Apo',
      'time': 'Tue 21 Oct. - 4:00PM',
      'status': 'Cancelled',
      'image': 'assets/images/potatoes.png',
    }
  ];

  List<Map<String, dynamic>> get _filteredOrders {
    if (_selectedTabIndex == 0) return _mockOrders.where((o) => o['status'] == 'Pending').toList();
    if (_selectedTabIndex == 1) return _mockOrders.where((o) => o['status'] == 'Confirmed').toList();
    return _mockOrders.where((o) => o['status'] == 'Cancelled').toList();
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
              child: const Center(
                child: Text(
                  'Orders',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            
            // 3. Main Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'My Orders',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF228B22),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Custom Tab Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTabItem(0, 'Pending'),
                        _buildTabItem(1, 'Confirmed'),
                        _buildTabItem(2, 'Cancelled'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  
                  // Order List or Empty State
                  Expanded(
                    child: _filteredOrders.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/order-1.svg',
                                  height: 250,
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  "We'll notify you when there's an order",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(20),
                            itemCount: _filteredOrders.length,
                            separatorBuilder: (context, index) => const Divider(height: 32, thickness: 1, color: Color(0xFFE0E0E0)),
                            itemBuilder: (context, index) {
                              final order = _filteredOrders[index];
                              return _buildOrderCard(order);
                            },
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

  Widget _buildTabItem(int index, String label) {
    bool isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          margin: EdgeInsets.only(right: index < 2 ? 8.0 : 0),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF228B22) : const Color(0xFFEAF5FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSelected) 
                const Icon(Icons.check, size: 16, color: Colors.white),
              if (isSelected) 
                const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Order Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
             height: 60, 
             width: 60,
             color: Colors.grey[200], 
                child: Image.asset(
                  order['image'], 
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.fastfood, color: Colors.grey)),
                ),
          ),
        ),
        const SizedBox(width: 12),
        // Order Details (Middle)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order['name'],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF228B22)),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Text(
                      order['location'],
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'Time: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    TextSpan(text: order['time'], style: const TextStyle(color: Color(0xFF228B22), fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Action Buttons (Right)
        Column(
          children: [
             if (_selectedTabIndex == 0) ...[
                // Pending: Cancel (Top) | Accept (Bottom)
                SizedBox(
                  width: 100,
                  child: _buildActionButton(
                       'Cancel', 
                       const Color(0xFFEAF5FF), 
                       const Color(0xFF228B22), // Text color for cancel
                       onTap: () {
                         setState(() {
                           order['status'] = 'Cancelled';
                         });
                         ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text('Order Cancelled')),
                         );
                       },
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 100,
                  child: _buildActionButton(
                       'Accept', 
                       const Color(0xFF228B22), 
                       Colors.white,
                       onTap: () {
                         setState(() {
                           order['status'] = 'Confirmed';
                           order['isReady'] = false; // Initialize to false
                         });
                         ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text('Order Confirmed')),
                         );
                       },
                  ),
                ),
             ] else if (_selectedTabIndex == 1) ...[
                // Confirmed: Preparing (Top) | Check Out (Bottom)
                SizedBox(
                  width: 100,
                  child: _buildActionButton('Preparing', 
                        (order['isReady'] ?? false) ? const Color(0xFFEAF5FF) : const Color(0xFF228B22), 
                        (order['isReady'] ?? false) ? const Color(0xFF228B22) : Colors.white,
                        isSolid: !(order['isReady'] ?? false)
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 100,
                  child: _buildActionButton('Check Out', 
                        (order['isReady'] ?? false) ? const Color(0xFF228B22) : const Color(0xFFEAF5FF), 
                        (order['isReady'] ?? false) ? Colors.white : const Color(0xFF228B22),
                        isSolid: (order['isReady'] ?? false)
                  ),
                ),
             ] else ...[
                 // Cancelled
                 SizedBox(
                   width: 100,
                   child: _buildActionButton('Cancelled', const Color(0xFFEAF5FF), const Color(0xFF228B22)),
                 ),
             ]
          ],
        )
      ],
    );
  }

  Widget _buildActionButton(String label, Color bgColor, Color textColor, {bool isSolid = true, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(5), 
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
