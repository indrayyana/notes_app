import 'package:dio/dio.dart';

Dio dio() {
  return Dio(
    BaseOptions(baseUrl: 'https://indrayana.pythonanywhere.com/', headers: {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    }),
  );
}
