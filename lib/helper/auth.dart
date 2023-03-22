import 'package:dio/dio.dart' as Dio;
import 'package:flutter/cupertino.dart';
import 'package:notesapp/helper/storage.dart';
import 'dio.dart';

class Auth extends ChangeNotifier {
  Future<Map> requestRegister(credentials) async {
    try {
      final res = await dio().post('user/user', data: credentials);

      if (res.data['error'] == false) {
        return {'status': true};
      } else {
        var errMsg = "";
        var message = res.data['message'];

        message.forEach((key, value) {
          errMsg += value[0] + "\n";
        });

        int index = errMsg.indexOf("\n");
        String firstMsg = errMsg.substring(0, index);

        if (firstMsg == "user with this username already exists.") {
          return {
            'status': false,
            'message':
                "Maaf, username tidak tersedia.\n Harap coba username lain.",
          };
        }

        return {
          'status': false,
          'message': errMsg,
        };
      }
    } on Dio.DioError {
      return {'status': false, 'error_msg': "Terjadi kesalahan"};
    }
  }

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  Future<Map> requestLogin(credentials) async {
    try {
      final res = await dio().post('user/token', data: credentials);

      if (res.data['access'] != null) {
        //Save token
        final accessToken = res.data['access'];
        await Storage().saveToken(accessToken);

        //State login
        _isAuthenticated = true;
        notifyListeners();

        return {
          'status': true,
        };
      } else {
        return {
          'status': false,
          'message': "Username atau password salah",
        };
      }
    } on Dio.DioError catch (e) {
      if (e.response?.data['detail'] ==
          "No active account found with the given credentials") {
        return {
          'status': false,
          'error_msg': "Username atau password salah",
        };
      } else {
        return {
          'status': false,
          'error_msg': "Terjadi kesalahan",
        };
      }
    }
  }

  Future<Map> requestLogout() async {
    try {
      final token = await Storage().readToken();
      if (token != null) {
        await Storage().deleteToken();

        //State login
        _isAuthenticated = false;
        notifyListeners();

        return {
          'status': true,
        };
      } else {
        return {
          'status': false,
          'message': "Sesi login tidak terdeteksi",
        };
      }
    } on Dio.DioError catch (e) {
      return {
        'status': false,
        'error_msg': "Terjadi kesalahan.\n${e.response}",
      };
    }
  }
}
