import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mon_pfapp/core/constants.dart';
import 'package:mon_pfapp/core/storage.dart';

class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

class ApiClient {
  static Future<Map<String, dynamic>> get(
    String path, {
    bool authenticated = false,
  }) async {
    final headers = await _headers(authenticated: authenticated);

    return _send(() => http.get(AppConstants.apiUri(path), headers: headers));
  }

  static Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    bool authenticated = false,
  }) async {
    final headers = await _headers(
      authenticated: authenticated,
      hasBody: body != null,
    );

    return _send(
      () => http.post(
        AppConstants.apiUri(path),
        headers: headers,
        body: body == null ? null : jsonEncode(body),
      ),
    );
  }

  static Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, dynamic>? body,
    bool authenticated = false,
  }) async {
    final headers = await _headers(
      authenticated: authenticated,
      hasBody: body != null,
    );

    return _send(
      () => http.patch(
        AppConstants.apiUri(path),
        headers: headers,
        body: body == null ? null : jsonEncode(body),
      ),
    );
  }

  static Future<Map<String, String>> _headers({
    required bool authenticated,
    bool hasBody = false,
  }) async {
    final headers = <String, String>{'Accept': 'application/json'};

    if (hasBody) headers['Content-Type'] = 'application/json';

    if (authenticated) {
      final token = await Storage.getToken();
      if (token == null || token.isEmpty) {
        throw const ApiException('Session non trouvee. Reconnectez-vous.');
      }
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  static Future<Map<String, dynamic>> _send(
    Future<http.Response> Function() request,
  ) async {
    try {
      final response = await request().timeout(AppConstants.apiTimeout);
      final data = _decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      }

      throw ApiException(_extractError(data, response.statusCode));
    } on TimeoutException {
      throw const ApiException('Le serveur ne repond pas.');
    } on FormatException {
      throw const ApiException('Reponse serveur invalide.');
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException('Impossible de joindre le serveur.');
    }
  }

  static Map<String, dynamic> _decode(String body) {
    if (body.trim().isEmpty) return {};

    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) return decoded;

    throw const FormatException('Unexpected JSON shape');
  }

  static String _extractError(Map<String, dynamic> data, int statusCode) {
    final message = data['message'];
    if (message is String && message.trim().isNotEmpty) return message;

    final errors = data['errors'];
    if (errors is Map && errors.values.isNotEmpty) {
      final first = errors.values.first;
      if (first is List && first.isNotEmpty) return first.first.toString();
      if (first is String && first.trim().isNotEmpty) return first;
    }

    return 'Erreur API ($statusCode).';
  }
}
