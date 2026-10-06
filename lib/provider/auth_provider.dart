import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthNotifier extends AsyncNotifier<String?> {
  final _dio = Dio();
  final _storage = FlutterSecureStorage();
  @override
  FutureOr<String?> build() async {
    String? token = await _storage.read(key: 'jwt_token');
    if (token == null) {
      return null;
    } else {
      return token;
    }
  }

  Future<bool> loginAndSave(String username, String password) async {
    try{final response = await _dio.post(
      "https://dummyjson.com/auth/login",
      data: {'username': username, 'password': password},
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    
      if(response.statusCode==200){
        String accessToken=response.data['accessToken'];
        await _storage.write(key: "jwt_token", value: accessToken);
        state=AsyncValue.data(accessToken);
        return true;
      }
    } on DioException catch (e) {
      print('Login failed: ${e.response?.data   ?? e.message}');
    }
    return false;
  }
}
final authNotifierProvider=AsyncNotifierProvider<AuthNotifier,String?>(AuthNotifier.new);