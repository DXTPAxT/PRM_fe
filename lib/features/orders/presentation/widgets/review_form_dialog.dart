import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Kết quả người dùng nhập trong form đánh giá.
class ReviewInput {
  final int rating;
  final String? comment;
  const ReviewInput({required this.rating, this.comment});
}

/// Dialog nhập đánh giá: chọn sao + bình luận. Trả về ReviewInput qua
/// Navigator.pop khi bấm Gửi, hoặc null nếu hủy.
class ReviewFormDialog extends StatefulWidget {
  final String productName;

  const ReviewFormDialog({super.key, required this.productName});

  @override
  State<ReviewFormDialog> createState() => _ReviewFormDialogState();
}

class _ReviewFormDialogState extends State<ReviewFormDialog> {
  int _rating = 5;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Đánh giá "${widget.productName}"'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Chất lượng sản phẩm'),
          const SizedBox(height: AppTheme.spaceS),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final star = index + 1;
              return IconButton(
                onPressed: () => setState(() => _rating = star),
                icon: Icon(
                  star <= _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 32,
                ),
              );
            }),
          ),
          const SizedBox(height: AppTheme.spaceS),
          TextField(
            controller: _commentController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Chia sẻ cảm nhận của bạn (tùy chọn)',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(
            context,
            ReviewInput(
              rating: _rating,
              comment: _commentController.text.trim(),
            ),
          ),
          child: const Text('Gửi đánh giá'),
        ),
      ],
    );
  }
}
