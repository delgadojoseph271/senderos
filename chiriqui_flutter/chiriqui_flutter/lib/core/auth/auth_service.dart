import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/api_client.dart';

class UserSession {
  final int id;
  final String name;
  final String email;
  final String? avatar;

  const UserSession({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
  });

  factory UserSession.fromJson(Map<String, dynamic> j) => UserSession(
    id: (j['id'] as num?)?.toInt() ?? 0,
    name: j['name'] ?? '',
    email: j['email'] ?? '',
    avatar: j['avatar'],
  );
}

class AuthService {
  final _storage = const FlutterSecureStorage();
  final _api = ApiClient.instance;

  Future<UserSession> login(String email, String password) async {
    final res = await _api.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    final token = res.data['token'] as String;
    await _storage.write(key: 'auth_token', value: token);
    return UserSession.fromJson(res.data['user']);
  }

  Future<UserSession> register(String name, String email, String password) async {
    final res = await _api.post('/auth/register', data: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password,
    });
    final token = res.data['token'] as String;
    await _storage.write(key: 'auth_token', value: token);
    return UserSession.fromJson(res.data['user']);
  }

  Future<void> logout() async {
    try { await _api.post('/auth/logout'); } catch (_) {}
    await _storage.delete(key: 'auth_token');
  }

  Future<bool> get isLoggedIn async {
    final token = await _storage.read(key: 'auth_token');
    return token != null;
  }

  Future<UserSession?> me() async {
    try {
      final res = await _api.get('/auth/me');
      return UserSession.fromJson(res.data);
    } catch (_) {
      return null;
    }
  }
}
