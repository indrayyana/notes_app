import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:notesapp/helper/dio.dart';
import 'package:notesapp/helper/storage.dart';
import 'package:notesapp/model/notes.dart';
import 'package:notesapp/model/notesDetail.dart';

class NoteAPI {
  Future fetchNote() async {
    try {
      final token = await Storage().readToken();
      final res = await dio().get(
        '',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (res.data['error'] == false) {
        return Notes.fromJson(json.decode(res.toString()));
      } else {
        throw "Terjadi kesalahan";
      }
    } catch (e) {
      return const Text('Sesi Anda telah berakhir, silahkan login kembali');
    }
  }

  Future fetchSingle(id) async {
    try {
      final token = await Storage().readToken();
      final res = await dio().get(
        '$id',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (res.data['error'] == false) {
        return NoteDetail.fromJson(json.decode(res.toString()));
      } else {
        throw "Terjadi kesalahan";
      }
    } catch (e) {
      return const Text('Sesi Anda telah berakhir, silahkan login kembali');
    }
  }

  Future addNote(data) async {
    try {
      final token = await Storage().readToken();
      final res = await dio().post(
        '',
        data: data,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (res.data['error'] == false) {
        return {'status': true};
      } else {
        var errMsg = "";
        var message = res.data['message'];

        message.forEach((key, value) {
          errMsg += value[0] + "\n";
        });

        return {
          'status': false,
          'message': errMsg,
        };
      }
    } catch (e) {
      return {'status': false, 'error_msg': "Terjadi kesalahan"};
    }
  }

  Future updateNote(id, data) async {
    try {
      final token = await Storage().readToken();
      final res = await dio().put(
        '$id',
        data: data,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (res.data['error'] == false) {
        return {'status': true};
      } else {
        var errMsg = "";
        var message = res.data['message'];

        message.forEach((key, value) {
          errMsg += value[0] + "\n";
        });

        return {
          'status': false,
          'message': errMsg,
        };
      }
    } catch (e) {
      return {'status': false, 'error_msg': "Terjadi kesalahan"};
    }
  }

  Future deleteNote(id) async {
    try {
      final token = await Storage().readToken();
      final res = await dio().delete(
        '$id',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (res.data['error'] == false) {
        return {'status': true};
      } else {
        var errMsg = "";
        var message = res.data['message'];

        message.forEach((key, value) {
          errMsg += value[0] + "\n";
        });

        return {
          'status': false,
          'message': errMsg,
        };
      }
    } catch (e) {
      return {'status': false, 'error_msg': "Terjadi kesalahan"};
    }
  }
}
