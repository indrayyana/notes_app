import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notesapp/API/noteApi.dart';
import 'package:notesapp/model/notesDetail.dart';
import 'package:notesapp/screen/addNotesScreen.dart';
import 'package:provider/provider.dart';

import '../helper/auth.dart';

class NoteDetailScreen extends StatefulWidget {
  final int? id;
  const NoteDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  Future? noteBuffer;
  bool _timeOut = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    noteBuffer = NoteAPI().fetchSingle(widget.id);
    startTimeOut();
    stopTimeOut();
  }

  startTimeOut() async {
    var duration = const Duration(seconds: 10);
    _timer = Timer(duration, () {
      if (mounted) {
        setState(() {
          _timeOut = true;
        });
      }
    });
  }

  stopTimeOut() async {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
      _timer = null;
    }
  }

  Future submitLogout() async {
    final res = await Provider.of<Auth>(context, listen: false).requestLogout();
    if (res['status'] == true) {
      Navigator.pushNamed(context, '/login');
    }
  }

  Container relog() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(10)),
      height: 170,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Sesi Anda telah berakhir.',
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const Text(
            'Silahkan login kembali.',
            style: TextStyle(fontSize: 20, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              submitLogout();
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void delete() {
    AlertDialog alertDialog = AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      content: SizedBox(
        height: 110,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Hapus Catatan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              'Anda yakin ingin menghapus catatan ini?',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('BATAL')),
                const SizedBox(width: 30),
                ElevatedButton(
                  onPressed: () {
                    NoteAPI().deleteNote(widget.id);
                    Navigator.pushNamed(context, '/home');
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        "Catatan Berhasil Dihapus",
                        style: TextStyle(fontSize: 16),
                      ),
                    ));
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  child: const Text('HAPUS'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    showDialog(
      context: context,
      builder: (context) => alertDialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan'),
        actions: [
          IconButton(
            onPressed: () {
              delete();
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      drawerScrimColor: Colors.transparent,
      body: FutureBuilder(
        future: noteBuffer,
        builder: ((context, snapshot) {
          if (snapshot.hasData && snapshot.data is NoteDetail) {
            final note = snapshot.data as NoteDetail;
            var date = note.date;
            return Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    date != null
                        ? DateFormat.yMMMMd("id_ID")
                            .format(DateTime.parse(date))
                        : "",
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    '${note.title}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    '${note.description}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 100),
                  Center(
                    child: ElevatedButton(
                      child: const Text(
                        'Edit Catatan',
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddNotes(id: note.id)));
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          return Scaffold(
            body: Center(
              child: _timeOut ? relog() : const CircularProgressIndicator(),
            ),
          );
        }),
      ),
    );
  }
}
