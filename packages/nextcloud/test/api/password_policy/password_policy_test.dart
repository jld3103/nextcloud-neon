import 'package:nextcloud/password_policy.dart' as password_policy;
import 'package:nextcloud_test/nextcloud_test.dart';
import 'package:test/test.dart';

void main() {
  presets('server', 'password_policy', (tester) {
    test('generate', () async {
      final response = await tester.client.passwordPolicy.api.generate();
      expect(response.body.ocs.data.password, isNotEmpty);
    });

    group('validate', () {
      test('pass', () async {
        final generateResponse = await tester.client.passwordPolicy.api.generate();
        expect(generateResponse.body.ocs.data.password, isNotEmpty);

        final validateResponse = await tester.client.passwordPolicy.api.validate(
          $body: password_policy.ApiValidateRequestApplicationJson(
            (b) => b.password = generateResponse.body.ocs.data.password,
          ),
        );
        expect(validateResponse.body.ocs.data.passed, isTrue);
        expect(validateResponse.body.ocs.data.reason, isNull);
      });

      test('fail', () async {
        final validateResponse = await tester.client.passwordPolicy.api.validate(
          $body: password_policy.ApiValidateRequestApplicationJson(
            (b) => b.password = '12345678',
          ),
        );
        expect(validateResponse.body.ocs.data.passed, isFalse);
        expect(validateResponse.body.ocs.data.reason, isNotEmpty);
      });
    });
  });
}
