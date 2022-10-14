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
    // from an old project, rewrite this as needed
    if(value == null) {
      return "* Error?"; //TODO is this possible?
    }

    if(value.length < 8) {
      return "* Password is too short";
    }

    return null;
  }

}