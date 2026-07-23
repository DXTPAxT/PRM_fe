import 'package:flutter_test/flutter_test.dart';

import 'package:clothing_store_app/core/utils/password_validator.dart';

void main() {
  group('validateStrongPassword', () {
    test('accepts a password with every required character type', () {
      expect(validateStrongPassword('Password1!'), isNull);
      expect(validateStrongPassword('Password1@'), isNull);
      expect(validateStrongPassword('MậtKhẩu2_'), isNull);
    });

    test('rejects an empty password', () {
      expect(validateStrongPassword(null), 'Vui lòng nhập mật khẩu');
      expect(validateStrongPassword(''), 'Vui lòng nhập mật khẩu');
    });

    test('rejects a password shorter than 8 characters', () {
      expect(
        validateStrongPassword('Pass1!'),
        'Mật khẩu phải có ít nhất 8 ký tự',
      );
    });

    test('rejects a password without an uppercase ASCII letter', () {
      expect(
        validateStrongPassword('password1!'),
        'Mật khẩu phải có ít nhất 1 chữ hoa',
      );
    });

    test('rejects a password without a digit', () {
      expect(
        validateStrongPassword('Password!'),
        'Mật khẩu phải có ít nhất 1 chữ số',
      );
    });

    test('rejects a password without a non-whitespace special character', () {
      expect(
        validateStrongPassword('Password1'),
        'Mật khẩu phải có ít nhất 1 ký tự đặc biệt',
      );
      expect(
        validateStrongPassword('Password1 '),
        'Mật khẩu phải có ít nhất 1 ký tự đặc biệt',
      );
      expect(
        validateStrongPassword('Password1Đ'),
        'Mật khẩu phải có ít nhất 1 ký tự đặc biệt',
      );
    });
  });
}
