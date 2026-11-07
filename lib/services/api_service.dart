import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/post.dart';
import '../models/user.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration defaultTimeout = Duration(seconds: 10);

  Future<List<User>> getUsers({
    Duration timeout = defaultTimeout,
  }) async {
    final uri = Uri.parse('$_baseUrl/users');
    try {
      final response = await http.get(uri).timeout(timeout);
      debugPrint('GET /users - status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is! List) {
          throw const FormatException('Format data pengguna tidak sesuai.');
        }
        return decoded
            .whereType<Map<String, dynamic>>()
            .map(User.fromJson)
            .toList();
      }

      throw HttpException(
        'Permintaan pengguna gagal (HTTP ${response.statusCode}).',
      );
    } on TimeoutException {
      debugPrint('GET /users - timeout');
      throw Exception('Permintaan terlalu lama. Periksa koneksi atau timeout.');
    } on SocketException {
      debugPrint('GET /users - network error');
      throw Exception('Tidak dapat terhubung ke server. Periksa internet.');
    } on FormatException {
      debugPrint('GET /users - format error');
      throw Exception('Format data dari server tidak valid.');
    } catch (e) {
      debugPrint('GET /users - request failed');
      rethrow;
    }
  }

  Future<User> getUserById(int id) async {
    final uri = Uri.parse('$_baseUrl/users/$id');
    try {
      final response =
          await http.get(uri).timeout(defaultTimeout);
      debugPrint('GET /users/$id - status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is! Map<String, dynamic>) {
          throw const FormatException('Format detail pengguna tidak sesuai.');
        }
        return User.fromJson(decoded);
      }
      throw HttpException(
        'Detail pengguna gagal dimuat (HTTP ${response.statusCode}).',
      );
    } on TimeoutException {
      throw Exception('Permintaan detail pengguna melewati batas waktu.');
    } on SocketException {
      throw Exception('Tidak dapat terhubung ke server.');
    } on FormatException {
      throw Exception('Format detail pengguna tidak valid.');
    }
  }

  Future<List<Post>> getPosts() async {
    final uri = Uri.parse('$_baseUrl/posts');
    try {
      final response =
          await http.get(uri).timeout(defaultTimeout);
      debugPrint('GET /posts - status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is! List) {
          throw const FormatException('Format data post tidak sesuai.');
        }
        return decoded
            .whereType<Map<String, dynamic>>()
            .map(Post.fromJson)
            .toList();
      }
      throw HttpException(
        'Permintaan post gagal (HTTP ${response.statusCode}).',
      );
    } on TimeoutException {
      throw Exception('Permintaan post melewati batas waktu.');
    } on SocketException {
      throw Exception('Tidak dapat terhubung ke server.');
    } on FormatException {
      throw Exception('Format data post tidak valid.');
    }
  }

  // Login simulasi untuk latihan; tidak mengirim kredensial ke server.
  Future<String> login(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!email.contains('@') || password.length < 6) {
      throw Exception('Email atau kata sandi tidak valid.');
    }

    final token =
        'demo_${DateTime.now().microsecondsSinceEpoch}_secure_token';
    debugPrint('Login simulasi berhasil.');
    return token;
  }
}
