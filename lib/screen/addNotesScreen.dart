import 'package:flutter/material.dart';
import 'package:notesapp/API/noteApi.dart';

class AddNotes extends StatefulWidget {
  final int? id;
  const AddNotes({Key? key, this.id}) : super(key: key);

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();

  bool _editMode = false;
  bool _hasError = false;
  String _errorMsg = "";

  @override
  void initState() {
    if (widget.id != null) {
      prefillForm(widget.id);
    }
    super.initState();
  }

  void prefillForm(id) async {
    final noteData = await NoteAPI().fetchSingle(widget.id);
    _titleCtrl.text = noteData.title;
    _descriptionCtrl.text = noteData.description;
    _editMode = true;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();

    super.dispose();
  }

  Future submitNote() async {
    var res;

    if (_editMode == false) {
      res = await NoteAPI().addNote({
        "title": _titleCtrl.text,
        "description": _descriptionCtrl.text,
      });
    } else {
      res = await NoteAPI().updateNote(widget.id, {
        "title": _titleCtrl.text,
        "description": _descriptionCtrl.text,
      });
    }

    if (res['status'] == true) {
      Navigator.pushNamed(context, '/home');
      _editMode
          ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                "Catatan Berhasil Diubah",
                style: TextStyle(fontSize: 16),
              ),
            ))
          : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                "Catatan Berhasil Ditambahkan",
                style: TextStyle(fontSize: 16),
              ),
            ));
    } else {
      setState(() {
        _hasError = true;
        _errorMsg = res['error_msg'] ?? res['message'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan'),
      ),
      drawerScrimColor: Colors.transparent,
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Judul',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _descriptionCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Deskripsi',
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: _hasError,
              child: Text(_errorMsg),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  submitNote();
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
