class ReviewInputValidator {
  String? validate(String? reviewText) {


    if(reviewText==null || reviewText.isEmpty) {
      return "This cannot be empty!";
    }

    return null;
  }
}