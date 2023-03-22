import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  final storage = const FlutterSecureStorage();
  final KEYAUTH = 'auth';

  Future<String?> readToken() async {
    return await storage.read(key: KEYAUTH);
  }

  saveToken(token) async {
    await storage.write(key: KEYAUTH, value: token);
  }

  deleteToken() async {
    await storage.delete(key: KEYAUTH);
  }
}
