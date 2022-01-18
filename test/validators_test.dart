import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/services/validators.dart';

void main() {
  test("Non empty string", () {
    final validator = NonEmptyStringValidator();
    expect(validator.isValid("test@test.com"), true);
  });

  test("Empty string", () {
    final validator = NonEmptyStringValidator();
    expect(validator.isValid(""), false);
  });
}
