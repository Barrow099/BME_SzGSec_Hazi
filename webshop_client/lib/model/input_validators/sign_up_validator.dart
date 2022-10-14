import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

class SignupValidator {
  TextEditingController passwordController;
  TextEditingController confirmPasswordController;

  SignupValidator(this.passwordController, this.confirmPasswordController);

  String? validateUserName(String? value) {
    //return null, if no errors, else return the error message

    return null;
  }

  String? validateEmailAddress(String value){
    //do we need both checks?

    bool emailValid = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(value);
    if(!emailValid){
      return "* Email address not valid";
    }

    if(!isEmail(value)){
      return "* Email address not valid";
    }

    return null;
  }

  String? validatePassword(String? value){
    // from an old project, rewrite this as needed
    if(value == null) {
      return "* Error?"; //TODO is this possible?
    }

    if(value.length < 8) {
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