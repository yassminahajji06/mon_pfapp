import 'package:flutter/material.dart';

import '../core/validators.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../widgets/app_ui.dart';

class RegisterScreen extends StatefulWidget {
  final ValueChanged<UserModel> onAuthenticated;
  final VoidCallback onLoginTap;

  const RegisterScreen({
    super.key,
    required this.onAuthenticated,
    required this.onLoginTap,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController(text: 'Yassmine Hajji');
  final _emailCtrl = TextEditingController(text: 'yassmine@email.com');
  final _phoneCtrl = TextEditingController(text: '+213 6 00 00 00 00');
  final _passwordCtrl = TextEditingController(text: 'demo123');
  bool _loading = false;
  bool _acceptTerms = true;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vous devez accepter les conditions d'utilisation."),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    setState(() => _loading = true);
    final result = await AuthService.register(
      nom: _nomCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      motDePasse: _passwordCtrl.text,
    );
    if (!mounted) return;

    setState(() => _loading = false);
    if (result['success'] == true && result['user'] is UserModel) {
      widget.onAuthenticated(result['user'] as UserModel);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] as String? ?? 'Inscription impossible.'),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          RedHeader(
            title: 'Creer un compte',
            subtitle: 'Rejoignez Mon PF App',
            leading: IconButton.filled(
              onPressed: widget.onLoginTap,
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.18),
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.arrow_back_rounded),
              tooltip: 'Retour',
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Inscription client',
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Les roles livreur et administrateur sont attribues par l'administration pour proteger l'application.",
                      style: TextStyle(color: AppColors.mutedText, fontSize: 12, height: 1.35),
                    ),
                    const SizedBox(height: 18),
                    _RegisterField(
                      label: 'Nom complet',
                      controller: _nomCtrl,
                      icon: Icons.person_outline,
                      validator: (v) => Validators.requiredText(v, 'Entrez votre nom'),
                    ),
                    const SizedBox(height: 14),
                    _RegisterField(
                      label: 'Adresse email',
                      controller: _emailCtrl,
                      icon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 14),
                    _RegisterField(
                      label: 'Telephone',
                      controller: _phoneCtrl,
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (v) => Validators.requiredText(v, 'Entrez votre telephone'),
                    ),
                    const SizedBox(height: 14),
                    _RegisterField(
                      label: 'Mot de passe',
                      controller: _passwordCtrl,
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: Validators.password,
                    ),
                    const SizedBox(height: 18),
                    CheckboxListTile(
                      value: _acceptTerms,
                      onChanged: (value) => setState(() => _acceptTerms = value ?? false),
                      activeColor: AppColors.red,
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        "J'accepte les conditions d'utilisation et la politique de confidentialite.",
                        style: TextStyle(fontSize: 12, color: AppColors.mutedText),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      label: _loading ? 'Creation...' : 'Creer mon compte',
                      onPressed: _loading ? null : _register,
                      icon: Icons.person_add_alt_1_rounded,
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: widget.onLoginTap,
                      style: TextButton.styleFrom(foregroundColor: AppColors.red),
                      child: const Text('Deja inscrit ? Se connecter'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RegisterField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;

  const _RegisterField({
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xFFF4F4F4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.red, width: 1.4),
        ),
      ),
    );
  }
}
