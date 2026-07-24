String? validateStrongPassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Vui lòng nhập mật khẩu';
  }
  if (value.length < 8) {
    return 'Mật khẩu phải có ít nhất 8 ký tự';
  }
  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return 'Mật khẩu phải có ít nhất 1 chữ hoa';
  }
  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return 'Mật khẩu phải có ít nhất 1 chữ số';
  }
  if (!RegExp(r'[\x21-\x2F\x3A-\x40\x5B-\x60\x7B-\x7E]').hasMatch(value)) {
    return 'Mật khẩu phải có ít nhất 1 ký tự đặc biệt';
  }
  return null;
}
