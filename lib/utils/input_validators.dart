class InputValidators {
  InputValidators._();

  static final RegExp _personNamePattern = RegExp(
    r"^[A-Za-z\u00C0-\u024F\u1E00-\u1EFF\u00D1\u00F1]+(?:[ .'’-][A-Za-z\u00C0-\u024F\u1E00-\u1EFF\u00D1\u00F1]+)*$",
  );

  static final RegExp _emailPattern = RegExp(
    r"^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?(?:\.[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?)+$",
  );

  static String? fullName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Please enter your full name';
    if (name.length < 3) return 'Enter at least 3 characters';
    if (name.length > 80) return 'Name must be 80 characters or fewer';
    if (!_personNamePattern.hasMatch(name)) {
      return 'Use letters, spaces, apostrophes, periods, or hyphens only';
    }
    if (name.split(RegExp(r'\s+')).length < 2) {
      return 'Please enter your first and last name';
    }
    return null;
  }

  static String? phone(String? value) {
    final phone = value?.trim() ?? '';
    if (phone.isEmpty) return 'Please enter your phone number';
    if (!RegExp(r'^\+?[0-9 ()-]+$').hasMatch(phone)) {
      return 'Use numbers and valid phone symbols only';
    }

    final normalized = phone.replaceAll(RegExp(r'[ ()-]'), '');
    final isValid = RegExp(r'^(?:\+639|639|09)\d{9}$').hasMatch(normalized);
    if (!isValid) return 'Enter a valid Philippine mobile number';
    return null;
  }

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return null;
    if (email.length > 254 || !_emailPattern.hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? optionalPersonName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return null;
    if (name.length > 80) return 'Name must be 80 characters or fewer';
    if (!_personNamePattern.hasMatch(name)) {
      return 'Use letters, spaces, apostrophes, periods, or hyphens only';
    }
    return null;
  }
}
