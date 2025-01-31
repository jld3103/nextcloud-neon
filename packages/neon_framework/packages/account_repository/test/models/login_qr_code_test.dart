import 'package:account_repository/src/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginQRcode', () {
    const qrCodePath = '/user:JohnDoe&password:super_secret&server:example.com';
    const qrCode = 'nc://login$qrCodePath';
    const invalidUrl = '::Not valid LoginQRcode::';
    final credentials = LoginQRcode(
      credentials: Credentials((b) {
        b
          ..serverURL = Uri.parse('example.com')
          ..username = 'JohnDoe'
          ..appPassword = 'super_secret';
      }),
    );

    test('parse', () {
      expect(LoginQRcode.parse(qrCode), equals(credentials));
      expect(LoginQRcode.parse(qrCodePath), equals(credentials));
      expect(() => LoginQRcode.parse(invalidUrl), throwsFormatException);
    });

    test('tryParse', () {
      expect(LoginQRcode.tryParse(qrCode), equals(credentials));
      expect(LoginQRcode.tryParse(qrCodePath), equals(credentials));
      expect(LoginQRcode.tryParse(invalidUrl), null);
    });

    test('equality', () {
      expect(credentials, equals(credentials));
    });

    test('toString', () {
      expect(
        credentials.toString(),
        equals(qrCode),
      );
    });
  });
}
