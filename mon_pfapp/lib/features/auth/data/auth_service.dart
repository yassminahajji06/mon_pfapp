import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mon_pfapp/core/constants.dart';
import 'package:mon_pfapp/core/storage.dart';
import 'package:mon_pfapp/data/demo_data.dart';
import 'package:mon_pfapp/domain/models/user_model.dart';

class AuthService {
  static Future<Map<String, dynamic>> register({
    required String nom,
    required String email,
    required String motDePasse,
  }) async {
    if (AppConstants.demoMode) {
      await Future<void>.delayed(const Duration(milliseconds: 350));
      return {
        'success': true,
        'user': UserModel(id: 1, nom: nom, email: email, role: 'client'),
      };
    }

    return _sendAuthRequest(
      endpoint: '/register',
      successStatusCode: 201,
      body: {'nom': nom, 'email': email, 'mot_de_passe': motDePasse},
      fallbackErrorMessage: 'Erreur lors de l\'inscription.',
    );
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String motDePasse,
  }) async {
    if (AppConstants.demoMode) {
      await Future<void>.delayed(const Duration(milliseconds: 350));
      return {'success': true, 'user': DemoData.demoUser};
    }

    return _sendAuthRequest(
      endpoint: '/login',
      successStatusCode: 200,
      body: {'email': email, 'mot_de_passe': motDePasse},
      fallbackErrorMessage: 'Email ou mot de passe incorrect.',
    );
  }

  static Future<void> logout() async {
    if (AppConstants.demoMode) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      return;
    }

    final token = await Storage.getToken();
    if (token == null || token.isEmpty) {
      await Storage.clear();
      return;
    }

    try {
      await http
          .post(
            AppConstants.apiUri('/logout'),
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          )
          .timeout(AppConstants.apiTimeout);
    } catch (_) {
      // Local logout must still happen even when the API is unavailable.
    }

    await Storage.clear();
  }

  static Future<Map<String, dynamic>> _sendAuthRequest({
    required String endpoint,
    required int successStatusCode,
    required Map<String, dynamic> body,
    required String fallbackErrorMessage,
  }) async {
    try {
      final response = await http
          .post(
            AppConstants.apiUri(endpoint),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(AppConstants.apiTimeout);

      final data = _decodeResponse(response.body);

      if (response.statusCode == successStatusCode) {
        final token = data['token'];
        final userJson = data['user'];

        if (token is! String || userJson is! Map<String, dynamic>) {
          return _failure('Réponse invalide du serveur.');
        }

        final user = UserModel.fromJson(userJson);
        await Storage.saveToken(token);
        await Storage.saveRole(user.role);

        return {'success': true, 'user': user};
      }

      return _failure(_extractErrorMessage(data, fallbackErrorMessage));
    } on TimeoutException {
      return _failure('Le serveur ne répond pas. Réessayez plus tard.');
    } on FormatException {
      return _failure('Réponse invalide du serveur.');
    } catch (_) {
      return _failure('Impossible de se connecter au serveur.');
    }
  }

  static Map<String, dynamic> _decodeResponse(String body) {
    if (body.trim().isEmpty) return {};

    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) return decoded;

    throw const FormatException('Unexpected response format');
  }

  static String _extractErrorMessage(
    Map<String, dynamic> data,
    String fallback,
  ) {
    final message = data['message'];
    if (message is String && message.trim().isNotEmpty) return message;

    final errors = data['errors'];
    if (errors is Map && errors.values.isNotEmpty) {
      final firstError = errors.values.first;
      if (firstError is List && firstError.isNotEmpty) {
        return firstError.first.toString();
      }
      if (firstError is String && firstError.trim().isNotEmpty) {
        return firstError;
      }
    }

    return fallback;
  }

  static Map<String, dynamic> _failure(String message) {
    return {'success': false, 'message': message};
  }
}
