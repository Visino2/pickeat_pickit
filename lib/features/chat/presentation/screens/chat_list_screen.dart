import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  int _selectedTabIndex = 0; // 0: Active Bookings, 1: Pending Bookings
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _activeChats = [
    {
      'name': 'Dianne Russell',
      'avatar': 'assets/images/russell.png',
      'lastMessage': 'I hope it goes well.',
      'time': '06:32 pm',
      'unreadCount': 2,
      'isRead': false,
    },
    {
      'name': 'Theresa Webb',
      'avatar': 'assets/images/webb.png',
      'lastMessage': 'I hope it goes well.',
      'time': '06:32 pm',
      'unreadCount': 0,
      'isRead': true,
    },
    {
      'name': 'Marvin McKinney',
      'avatar': 'assets/images/marvin.png',
      'lastMessage': 'I hope it goes well.',
      'time': '06:32 pm',
      'unreadCount': 2,
      'isRead': false,
    },
    {
      'name': 'Bessie Cooper',
      'avatar': 'assets/images/copper.png',
      'lastMessage': 'I hope it goes well.',
      'time': '06:32 pm',
      'unreadCount': 0,
      'isRead': false,
    },
    {
      'name': 'Devon Lane',
      'avatar': 'assets/images/lane.png',
      'lastMessage': 'I hope it goes well.',
      'time': '06:32 pm',
      'unreadCount': 0,
      'isRead': true,
    },
    {
      'name': 'Wade Warren',
      'avatar': 'assets/images/warren.png',
      'lastMessage': 'I hope it goes well.',
      'time': '06:32 pm',
      'unreadCount': 0,
      'isRead': true,
    },
    {
      'name': 'Darlene Robertson',
      'avatar': 'assets/images/robertson.png',
      'lastMessage': 'I hope it goes well.',
      'time': '06:32 pm',
      'unreadCount': 0,
      'isRead': true,
    },
    {
      'name': 'Jenny Wilson',
      'avatar': 'assets/images/wilson.png',
      'lastMessage': 'I hope it goes well.',
      'time': '06:32 pm',
      'unreadCount': 0,
      'isRead': true,
    },
  ];

  final List<Map<String, dynamic>> _pendingChats = [];

  List<Map<String, dynamic>> get _currentChats =>
      _selectedTabIndex == 0 ? _activeChats : _pendingChats;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
            // Green Status Bar
            Container(
              color: const Color(0xFF228B22),
              height: MediaQuery.of(context).padding.top,
            ),

            // Search Bar — separated from green bar, #DCDFED background
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCDFED),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Icon(Icons.search, color: Colors.grey[500], size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search  Messages',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Messages Header & Tabs
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Messages',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF228B22),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Tab Bar
                  Row(
                    children: [
                      _buildTab(0, 'Active Bookings'),
                      const SizedBox(width: 12),
                      _buildTab(1, 'Pending Bookings'),
                    ],
                  ),
                ],
              ),
            ),

            // Divider line under tabs
            Container(height: 1, color: Colors.grey[200]),

            // Chat List
            Expanded(
              child: _currentChats.isEmpty
                  ? const Center(
                      child: Text(
                        'No messages yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: _currentChats.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        thickness: 2,
                        color: Colors.grey[200],
                        indent: 84,
                      ),
                      itemBuilder: (context, index) {
                        final chat = _currentChats[index];
                        return _buildChatItem(chat);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(int index, String label) {
    bool isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF228B22) : const Color(0xFFDCDFED),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatItem(Map<String, dynamic> chat) {
    final bool hasUnread = (chat['unreadCount'] as int) > 0;
    final bool isRead = chat['isRead'] as bool;

    return InkWell(
      onTap: () {
        // Navigate to chat conversation screen with contact info
        context.push('/chat/conversation', extra: {
          'name': chat['name'],
          'avatar': chat['avatar'],
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Avatar with online dot
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(chat['avatar']),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFF228B22),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),

            // Name & Last Message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat['name'],
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Read receipt icon
                      if (!hasUnread)
                        Icon(
                          Icons.done_all,
                          size: 16,
                          color: isRead ? const Color(0xFF228B22) : Colors.grey[400],
                        ),
                      if (!hasUnread) const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          chat['lastMessage'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Time & Unread Badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  chat['time'],
                  style: TextStyle(
                    fontSize: 12,
                    color: hasUnread ? const Color(0xFF228B22) : Colors.grey[500],
                    fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 6),
                if (hasUnread)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF228B22),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${chat['unreadCount']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
