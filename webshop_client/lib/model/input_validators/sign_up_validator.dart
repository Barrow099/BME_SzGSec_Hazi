import 'package:flutter/material.dart';

class SignupValidator {
  TextEditingController passwordController;
  TextEditingController confirmPasswordController;

  SignupValidator(this.passwordController, this.confirmPasswordController);

  String? validateUserName(String? value) {
    //return null, if no errors, else return the error message
    if(value == null || value.length < 2) {
      return "* User name is too short";
    }

    return null;
  }

  String? validateEmailAddress(String? value){
    if(value == null || value.isEmpty) {
      return "* Email address cannot be empty";
    }

    bool emailValid = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(value);
    if(!emailValid){
      return "* Email address not valid";
    }

    return null;
  }

  String? validatePassword(String? value){
    if(value == null || value.length < 8) {
      return "* Password is too short";
    }

    return null;
  }

  String? validateConfirmPassword(String? value){
    if(passwordController.text != confirmPasswordController.text) {
      return "* Passwords don't match";
    }
    return null;
  }
}