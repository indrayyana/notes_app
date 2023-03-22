import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notesapp/screen/appDrawer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../API/noteAPI.dart';
import '../helper/auth.dart';
import '../model/notes.dart';
import 'noteDetailScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future? notesBuffer;
  bool _timeOut = false;

  @override
  void initState() {
    super.initState();
    notesBuffer = NoteAPI().fetchNote();
    startTimeOut();
  }

  startTimeOut() async {
    var duration = const Duration(seconds: 10);
    return Timer(duration, () {
      setState(() {
        _timeOut = true;
      });
    });
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
      padding: const EdgeInsets.all(30),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan'),
      ),
      drawerScrimColor: Colors.transparent,
      body: FutureBuilder(
        future: notesBuffer,
        builder: ((context, snapshot) {
          if (snapshot.hasData && snapshot.data is Notes) {
            return NoteListWidget(notes: (snapshot.data as Notes).notes);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return Center(
            child: _timeOut ? relog() : const CircularProgressIndicator(),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/notes');
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      drawer: const AppDrawer(),
    );
  }
}

class NoteListWidget extends StatefulWidget {
  final notes;
  const NoteListWidget({Key? key, required this.notes}) : super(key: key);

  @override
  State<NoteListWidget> createState() => _NoteListWidgetState();
}

class _NoteListWidgetState extends State<NoteListWidget> {
  List<Note>? _noteList;

  @override
  void initState() {
    super.initState();
    _noteList = widget.notes;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _noteList?.length,
        itemBuilder: (context, index) {
          var item = _noteList?[index];
          var date = item?.date;
          return ListTile(
            title: Text('${item?.title}'),
            subtitle: Text(date != null
                ? DateFormat.yMMMMd("id_ID").format(DateTime.parse(date))
                : ""),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NoteDetailScreen(id: item?.id)),
              );
            },
          );
        });
  }
}
