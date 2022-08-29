class NoteModel {
  late String id;
  late String title;
  late String info;

  NoteModel();

  NoteModel.fromJson(Map<String,dynamic>toMap){
    title = toMap['title'];
    info = toMap['info'];
  }

  Map<String,dynamic>toMap(){
    Map<String,dynamic>map = <String,dynamic>{};
    map['title'] = title ;
    map['info'] = info ;
    return map;
  }
}
