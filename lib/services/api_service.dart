import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_model.dart';
import '../models/category_model.dart';

class ApiService {
  static const String baseUrl =
      'https://fashlabstudio.mytechrcm.com/api/v1/index.php';

  static String? _cookie;
  static String? _deviceToken;

  // ============================================================
  // SESSION
  // ============================================================

  static Future<void> initSession() async {
    final prefs = await SharedPreferences.getInstance();

    _cookie = prefs.getString('session_cookie');
    _deviceToken = prefs.getString('device_token');

    if (_deviceToken == null || _deviceToken!.isEmpty) {
      await _startNewSession();
    }
  }

  static Future<void> _startNewSession() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/session'),
        headers: _buildHeaders(),
        body: jsonEncode({
          'platform': 'android',
          'device_name': 'Flutter App',
        }),
      );

      _updateSessionFromResponse(response);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['success'] == true &&
            body['data'] != null) {
          final newToken =
          body['data']['token']?.toString();

          if (newToken != null && newToken.isNotEmpty) {
            _deviceToken = newToken;

            final prefs =
            await SharedPreferences.getInstance();

            await prefs.setString(
              'device_token',
              _deviceToken!,
            );
          }
        }
      }
    } catch (e) {
      debugPrint(
        'Session Start Error: $e',
      );
    }
  }

  static Map<String, String> _buildHeaders() {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (_cookie != null && _cookie!.isNotEmpty) {
      headers['Cookie'] = _cookie!;
    }

    if (_deviceToken != null &&
        _deviceToken!.isNotEmpty) {
      headers['Device-Token'] = _deviceToken!;
      headers['X-Device-Token'] = _deviceToken!;
      headers['Authorization'] =
      'Bearer $_deviceToken';
    }

    return headers;
  }

  static Uri _buildUri(String endpoint) {
    final url = '$baseUrl$endpoint';

    if (_deviceToken != null &&
        _deviceToken!.isNotEmpty) {
      final separator =
      url.contains('?') ? '&' : '?';

      return Uri.parse(
        '$url${separator}device_token=$_deviceToken',
      );
    }

    return Uri.parse(url);
  }

  static Future<void> _updateSessionFromResponse(
      http.Response response,
      ) async {
    final rawCookie = response.headers['set-cookie'];

    if (rawCookie != null && rawCookie.isNotEmpty) {
      final cookiePart = rawCookie.split(';').first;

      _cookie = cookiePart;

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        'session_cookie',
        _cookie!,
      );

      debugPrint('SESSION COOKIE SAVED: $_cookie');
    }
  }

  // ============================================================
  // GET
  // ============================================================

  static Future<Map<String, dynamic>> get(
      String endpoint,
      ) async {
    await _ensureSession();

    final response = await http.get(
      _buildUri(endpoint),
      headers: _buildHeaders(),
    );

    await _updateSessionFromResponse(response);

    debugPrint(
      'GET $endpoint → ${response.statusCode}',
    );

    return jsonDecode(response.body);
  }

  // ============================================================
  // POST
  // ============================================================

  static Future<Map<String, dynamic>> post(
      String endpoint, {
        Map<String, dynamic>? body,
      }) async {
    await _ensureSession();

    final response = await http.post(
      _buildUri(endpoint),
      headers: _buildHeaders(),
      body: body != null
          ? jsonEncode(body)
          : null,
    );

    await _updateSessionFromResponse(response);

    debugPrint(
      'POST $endpoint → ${response.statusCode}',
    );

    return jsonDecode(response.body);
  }

  // ============================================================
  // PATCH
  // ============================================================

  static Future<Map<String, dynamic>> patch(
      String endpoint, {
        Map<String, dynamic>? body,
      }) async {
    await _ensureSession();

    final response = await http.patch(
      _buildUri(endpoint),
      headers: _buildHeaders(),
      body: body != null
          ? jsonEncode(body)
          : null,
    );

    await _updateSessionFromResponse(response);

    debugPrint(
      'PATCH $endpoint → ${response.statusCode}',
    );

    return jsonDecode(response.body);
  }
  // ============================================================
// DELETE
// ============================================================

  static Future<Map<String, dynamic>> delete(
      String endpoint, {
        Map<String, dynamic>? body,
      }) async {
    await _ensureSession();

    final response = await http.delete(
      _buildUri(endpoint),
      headers: _buildHeaders(),
      body: body != null
          ? jsonEncode(body)
          : null,
    );

    await _updateSessionFromResponse(response);

    debugPrint(
      'DELETE $endpoint → ${response.statusCode}',
    );

    return jsonDecode(response.body);
  }

  // ============================================================
  // SESSION CHECK
  // ============================================================

  static Future<void> _ensureSession() async {
    if (_deviceToken == null ||
        _deviceToken!.isEmpty) {
      await initSession();
    }
  }

  // ============================================================
  // PRODUCTS
  // ============================================================

  static Future<List<ProductModel>> fetchProducts({
    String sort = 'newest',
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await get(
      '/products'
          '?sort=$sort'
          '&page=$page'
          '&per_page=$perPage',
    );

    if (response['success'] != true) {
      throw Exception(
        response['message']?.toString() ??
            'Unable to load products',
      );
    }

    final data = response['data'];

    if (data is! Map) {
      throw Exception(
        'Invalid products response from API',
      );
    }

    final items = data['items'];

    if (items is! List) {
      throw Exception(
        'Products list not found in API response',
      );
    }

    return items
        .map(
          (item) => ProductModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }

  static Future<List<ProductModel>> fetchShopProducts({
    String? query,
    String? category,
    String? price,
    String? sort,
    String? fabric,
    bool sale = false,
    bool featured = false,
  }) async {
    final params = <String, String>{
      'page': '1',
      'per_page': '120',
    };

    if (query != null && query.trim().isNotEmpty) {
      params['q'] = query.trim();
    }

    if (category != null && category.trim().isNotEmpty) {
      params['category'] = category.trim();
    }

    if (price != null && price.trim().isNotEmpty) {
      params['price'] = price.trim();
    }

    if (sort != null && sort.trim().isNotEmpty) {
      params['sort'] = sort.trim();
    }

    if (fabric != null && fabric.trim().isNotEmpty) {
      params['fabric'] = fabric.trim();
    }

    if (sale) {
      params['sale'] = '1';
    }

    if (featured) {
      params['featured'] = '1';
    }

    final queryString = params.entries
        .map(
          (entry) =>
      '${Uri.encodeQueryComponent(entry.key)}='
          '${Uri.encodeQueryComponent(entry.value)}',
    )
        .join('&');

    final response = await get(
      '/products?$queryString',
    );

    if (response['success'] != true) {
      throw Exception(
        response['message']?.toString() ??
            'Unable to load shop products',
      );
    }

    final data = response['data'];

    if (data is! Map) {
      throw Exception(
        'Invalid shop products response from API',
      );
    }

    final items = data['items'];

    if (items is! List) {
      throw Exception(
        'Products list not found in API response',
      );
    }

    return items
        .map(
          (item) => ProductModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }

  // ============================================================
  // ALL CATEGORIES
  // ============================================================

  static Future<List<CategoryModel>>
  fetchCategories() async {
    final response =
    await get('/categories');

    if (response['success'] != true) {
      throw Exception(
        response['message']?.toString() ??
            'Unable to load categories',
      );
    }

    final data = response['data'];

    if (data is! Map) {
      throw Exception(
        'Invalid categories response from API',
      );
    }

    final items = data['items'];

    if (items is! List) {
      throw Exception(
        'Categories list not found in API response',
      );
    }

    return items
        .map(
          (item) => CategoryModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }

  // ============================================================
  // NEWSLETTER
  // ============================================================

  static Future<Map<String, dynamic>>
  subscribeNewsletter(
      String email,
      ) async {
    return await post(
      '/newsletter',
      body: {
        'email': email,
      },
    );
  }
}