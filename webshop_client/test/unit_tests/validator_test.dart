import 'package:flutter/cupertino.dart';
import 'package:test/test.dart';
import 'package:webshop_client/model/input_validators/login_validator.dart';
import 'package:webshop_client/model/input_validators/sign_up_validator.dart';

void main() {
  group("LoginValidator", () {

    test("Username returns null on correct username", () {
      final validator = LoginValidator();
      expect(validator.validateUserName("MyUserName"), isNull);
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
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    test("Error on empty password", () {
      final validator = SignupValidator(passwordController, confirmPasswordController);

      const pw = "";
      const confirmPw = "";

      passwordController.text = pw;
      confirmPasswordController.text = confirmPw;

      expect(validator.validatePassword(pw), isNotNull);
      expect(validator.validatePassword(pw), "* Password is too short");
    });

    //TODO other validator tests

  });

}