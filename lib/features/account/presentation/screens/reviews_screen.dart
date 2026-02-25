import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

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
            // Green status bar
            Container(
              color: const Color(0xFF228B22),
              height: MediaQuery.of(context).padding.top,
            ),
            // App bar with shadow
            Container(
              height: kToolbarHeight,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 50,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => context.pop(),
                  ),
                  const Expanded(
                    child: Text(
                      'Reviews',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Reviews summary section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Reviews',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Rating number
                          const Text(
                            '4.7',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Stars row
                          Row(
                            children: List.generate(5, (index) {
                              if (index < 4) {
                                return const Icon(
                                  Icons.star,
                                  color: Color(0xFF228B22),
                                  size: 28,
                                );
                              } else {
                                return const Icon(
                                  Icons.star_half,
                                  color: Color(0xFF228B22),
                                  size: 28,
                                );
                              }
                            }),
                          ),
                          const SizedBox(height: 6),

                          // Reviews count
                          Text(
                            '(578 Reviews)',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Star breakdown bars
                          _buildStarBar('5 stars', 488, 488),
                          const SizedBox(height: 8),
                          _buildStarBar('4 stars', 74, 488),
                          const SizedBox(height: 8),
                          _buildStarBar('3 stars', 14, 488),
                          const SizedBox(height: 8),
                          _buildStarBar('2 stars', 0, 488),
                          const SizedBox(height: 8),
                          _buildStarBar('1 star', 0, 488),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Divider
                    Divider(
                      color: Colors.grey[200],
                      thickness: 1,
                      height: 1,
                    ),

                    const SizedBox(height: 8),

                    // Individual reviews
                    _buildReviewItem(
                      initials: 'AK',
                      name: 'Alex K.',
                      date: 'Jan 20, 2024',
                      rating: 5,
                      review:
                          'I love the meal it was great, and yeah the delivery was fast',
                    ),
                    _buildReviewItem(
                      initials: 'AK',
                      name: 'Alex K.',
                      date: 'Jan 20, 2024',
                      rating: 5,
                      review:
                          'I love the meal it was great, and yeah the delivery was fast',
                    ),
                    _buildReviewItem(
                      initials: 'AK',
                      name: 'Alex K.',
                      date: 'Jan 20, 2024',
                      rating: 5,
                      review:
                          'I love the meal it was great, and yeah the delivery was fast',
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarBar(String label, int count, int maxCount) {
    final double ratio = maxCount > 0 ? count / maxCount : 0;
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Stack(
            children: [
              // Background bar
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              // Filled bar
              FractionallySizedBox(
                widthFactor: ratio,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF228B22),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 30,
          child: Text(
            '$count',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewItem({
    required String initials,
    required String name,
    required String date,
    required int rating,
    required String review,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Date
          Text(
            date,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 12),

          // Avatar + Name
          Row(
            children: [
              // Avatar circle
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF228B22),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Stars
          Row(
            children: List.generate(
              rating,
              (index) => const Icon(
                Icons.star,
                color: Color(0xFF228B22),
                size: 22,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Review text
          Text(
            review,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),

          // Reply button
          Text(
            'Reply',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),

          // Divider
          const SizedBox(height: 12),
          Divider(
            color: Colors.grey[200],
            thickness: 1,
            height: 1,
          ),
        ],
      ),
    );
  }
}
