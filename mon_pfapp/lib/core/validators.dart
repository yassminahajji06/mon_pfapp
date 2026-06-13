class Validators {
  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  static String? requiredText(String? value, String message) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Entrez votre email';
    if (!_emailPattern.hasMatch(email)) return 'Email invalide';
    return null;
  }

  static String? password(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Entrez votre mot de passe';
    if (password.length < 6) return 'Minimum 6 caractères';
    return null;
  }
}
