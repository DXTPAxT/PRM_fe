/// Định dạng giá kiểu Việt Nam: 250000 -> "250.000 ₫".
/// Hỗ trợ số âm (dùng cho dòng giảm giá): -50000 -> "-50.000 ₫".
String formatVnd(num amount) {
  final rounded = amount.round();
  final negative = rounded < 0;
  final digits = rounded.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return '${negative ? '-' : ''}${buffer.toString()} ₫';
}

/// Định dạng ngày giờ ngắn gọn: 20/07/2026 14:30.
String formatDateTime(DateTime dt) {
  final local = dt.toLocal();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(local.day)}/${two(local.month)}/${local.year} '
      '${two(local.hour)}:${two(local.minute)}';
}
