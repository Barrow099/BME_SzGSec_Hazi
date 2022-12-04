class LoginValidator {
  //do we need this at all?

  String? validateUserName(String? value) {
    //return null, if no errors, else return the error message
    if(value == null) {
      return "User name is somehow null!";
    }

    if(value.isEmpty) {
      return "Username cannot be empty";
    }

    return null;
  }

  String? validatePassword(String? value){
    if(value == null || value.length < 8) {
      return "* Password is too short";
    }

    return null;
  }

}