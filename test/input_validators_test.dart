import 'package:barbershop_app/utils/input_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('full name validation', () {
    test('accepts common Filipino names', () {
      expect(InputValidators.fullName('Juan Dela Cruz'), isNull);
      expect(InputValidators.fullName("María D'Angelo-Santos"), isNull);
    });

    test('rejects missing, single, numeric, and symbol-heavy names', () {
      expect(InputValidators.fullName(''), isNotNull);
      expect(InputValidators.fullName('Juan'), isNotNull);
      expect(InputValidators.fullName('Juan123 Cruz'), isNotNull);
      expect(InputValidators.fullName('Juan @ Cruz'), isNotNull);
    });
  });

  group('phone validation', () {
    test('accepts supported Philippine mobile formats', () {
      expect(InputValidators.phone('0917 123 4567'), isNull);
      expect(InputValidators.phone('+63 917 123 4567'), isNull);
      expect(InputValidators.phone('639171234567'), isNull);
    });

    test('rejects invalid phone numbers', () {
      expect(InputValidators.phone(''), isNotNull);
      expect(InputValidators.phone('0917ABC4567'), isNotNull);
      expect(InputValidators.phone('0917123456'), isNotNull);
      expect(InputValidators.phone('08171234567'), isNotNull);
    });
  });

  group('email validation', () {
    test('allows an empty optional email and valid addresses', () {
      expect(InputValidators.email(''), isNull);
      expect(InputValidators.email('juan.cruz+booking@example.com'), isNull);
    });

    test('rejects malformed addresses', () {
      expect(InputValidators.email('juan@'), isNotNull);
      expect(InputValidators.email('juan @example.com'), isNotNull);
      expect(InputValidators.email('juan@example'), isNotNull);
    });
  });

  group('optional referrer validation', () {
    test('allows empty and person-name values', () {
      expect(InputValidators.optionalPersonName(''), isNull);
      expect(InputValidators.optionalPersonName('Barber Carlo'), isNull);
    });

    test('rejects digits and unsupported symbols', () {
      expect(InputValidators.optionalPersonName('Barber 2'), isNotNull);
      expect(InputValidators.optionalPersonName('Carlo @ MOA'), isNotNull);
    });
  });
}
