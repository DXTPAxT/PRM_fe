import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/review.dart';

class ReviewFormResult {
  final int rating;
  final String? comment;

  const ReviewFormResult({required this.rating, this.comment});
}

Future<ReviewFormResult?> showReviewFormSheet(
  BuildContext context, {
  Review? existing,
}) {
  return showModalBottomSheet<ReviewFormResult>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _ReviewForm(existing: existing),
  );
}

class _ReviewForm extends StatefulWidget {
  final Review? existing;
  const _ReviewForm({this.existing});

  @override
  State<_ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<_ReviewForm> {
  late int _rating;
  late final TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _rating = widget.existing?.rating ?? 5;
    _commentController =
        TextEditingController(text: widget.existing?.comment ?? '');
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;

    return Padding(
      padding: EdgeInsets.only(
        left: AppTheme.spaceL,
        right: AppTheme.spaceL,
        top: AppTheme.spaceL,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppTheme.spaceL,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEditing ? 'Sửa đánh giá' : 'Viết đánh giá',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppTheme.spaceL),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final star = index + 1;
              return IconButton(
                iconSize: 36,
                icon: Icon(
                  star <= _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () => setState(() => _rating = star),
              );
            }),
          ),
          const SizedBox(height: AppTheme.spaceM),
          TextField(
            controller: _commentController,
            maxLines: 4,
            maxLength: 1000,
            decoration: const InputDecoration(
              labelText: 'Nhận xét (không bắt buộc)',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: AppTheme.spaceM),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed: () => Navigator.of(context).pop(
              ReviewFormResult(
                rating: _rating,
                comment: _commentController.text.trim(),
              ),
            ),
            child: Text(isEditing ? 'Cập nhật' : 'Gửi đánh giá'),
          ),
        ],
      ),
    );
  }
}
