import 'dart:convert';
import 'package:http/http.dart' as http;

class Http {
  final Map<String, String> defaultHeaders;

  Http({this.defaultHeaders = const {'Content-Type': 'application/json'}});

  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {...defaultHeaders, if (headers != null) ...headers},
    );
    return _processResponse(response);
  }

  Future<dynamic> post(String url, {Map<String, String>? headers, dynamic body}) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {...defaultHeaders, if (headers != null) ...headers},
      body: body != null ? jsonEncode(body) : null,
    );
    return _processResponse(response);
  }

  Future<dynamic> put(String url, {Map<String, String>? headers, dynamic body}) async {
    final response = await http.put(
      Uri.parse(url),
      headers: {...defaultHeaders, if (headers != null) ...headers},
      body: body != null ? jsonEncode(body) : null,
    );
    return _processResponse(response);
  }

  Future<dynamic> delete(String url, {Map<String, String>? headers}) async {
    final response = await http.delete(
      Uri.parse(url),
      headers: {...defaultHeaders, if (headers != null) ...headers},
    );
    return _processResponse(response);
  }

  dynamic _processResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    if (statusCode >= 200 && statusCode < 300) {
      try {
        return jsonDecode(body);
      } catch (e) {
        return body;
      }
    } else {
      throw HttpException(
        'Request failed with status: $statusCode, body: $body',
        statusCode,
      );
    }
  }
}

class HttpException implements Exception {
  final String message;
  final int? statusCode;

  HttpException(this.message, [this.statusCode]);

  @override
  String toString() => 'HttpException: $message';
}
