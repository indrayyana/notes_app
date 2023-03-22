class Notes {
  List<Note>? notes;

  Notes({this.notes});

  Notes.fromJson(json) {
    notes = [];

    json['data'].forEach((item) {
      notes?.add(Note.fromJson(item));
    });
  }
}

class Note {
  int? id;
  String? title;
  String? date;

  Note({this.id, this.title, this.date});

  factory Note.fromJson(json) {
    return Note(
      id: json['id'],
      title: json['title'],
      date: json['date'],
    );
  }
}
