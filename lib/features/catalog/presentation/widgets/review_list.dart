import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/review.dart';

class ReviewList extends StatelessWidget {
  final List<Review> reviews;
  final int maxItems;

  const ReviewList({
    super.key,
    required this.reviews,
    this.maxItems = 3,
  });

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceM),
        child: Text(
          'Chưa có đánh giá nào. Hãy là người đầu tiên!',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }

    final visible = reviews.take(maxItems).toList();

    return Column(
      children: visible.map((review) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    child: Text(
                      review.userFullName.isNotEmpty
                          ? review.userFullName[0].toUpperCase()
                          : '?',
                    ),
                  ),
                  const SizedBox(width: AppTheme.spaceS),
                  Expanded(
                    child: Text(
                      review.userFullName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < review.rating
                            ? Icons.star
                            : Icons.star_border,
                        size: 14,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
              if (review.comment != null && review.comment!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Text(review.comment!),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}
