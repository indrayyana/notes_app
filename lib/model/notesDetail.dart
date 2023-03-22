class NoteDetail {
  int? id;
  String? title;
  String? description;
  String? date;

  NoteDetail({this.id, this.title, this.description, this.date});

  factory NoteDetail.fromJson(json) {
    var data = json['data'];
    return NoteDetail(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      date: data['date'],
    );
  }
}
