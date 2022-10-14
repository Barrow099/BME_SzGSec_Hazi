import 'package:test/test.dart';
import 'package:webshop_client/model/input_validators/login_validator.dart';

void main() {
  group("LoginValidator", () {

    test("Username returns null on correct username", () {
      final validator = LoginValidator();
      expect(validator.validateUserName("MyUserName"), null);
    });

    test("Username returns error on null username", () {
      final validator = LoginValidator();
      expect(validator.validateUserName(null), isNotNull);
      expect(validator.validateUserName(null), "User name is somehow null!");
    });

    test("Username returns error on empty username", () {
      final validator = LoginValidator();
      expect(validator.validateUserName(""), isNotNull);
      expect(validator.validateUserName(""), "Username cannot be empty");
    });

  });

  group("Signup validator", () {
    //TODO signup validator

  });

}