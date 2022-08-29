import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/note_model.dart';

class FirebaseFireStoreController {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  Future<bool> create({required NoteModel noteModel}) async {
    return await _instance
        .collection('Notes')
        .add(noteModel.toMap())
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> delete({required String path}) async {
    return await _instance
        .collection('Notes')
        .doc(path)
        .delete()
        .then((value) => true)
        .catchError((onError) => false);
  }

  Future<bool> update({required NoteModel noteModel}) async {
    return await _instance
        .collection('Notes')
        .doc(noteModel.id)
        .update(noteModel.toMap())
        .then((value) => true)
        .catchError((onError) => false);
  }

  Stream<QuerySnapshot<NoteModel>> read() async* {
   yield* _instance
        .collection('Notes')
        .withConverter<NoteModel>(
          fromFirestore: (snapshot, options) =>
              NoteModel.fromJson(snapshot.data()!),
          toFirestore: (NoteModel noteModel, options) => NoteModel().toMap(),
        )
        .snapshots();
  }
}
