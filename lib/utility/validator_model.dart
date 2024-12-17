class ValidatorModel {
  static String? notEmptyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "required field";
    }

    return null;
  }
}
