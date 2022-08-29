import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_course/firebase/firebase_auth_controller.dart';
import 'package:firebase_course/firebase/firebase_firestore.dart';
import 'package:firebase_course/model/note_model.dart';
import 'package:firebase_course/screen/note/notes.dart';
import 'package:firebase_course/utils/helper.dart';
import 'package:flutter/material.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> with Helper {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actionsIconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotesScreen(),
                    ),
                  ),
              icon: const Icon(Icons.create)),
          IconButton(
            onPressed: () async {
              unawaited(FirebaseAuthController().logeOut());
              Navigator.pushReplacementNamed(context, '/login_screen');
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
        title: const Text(
          'Home Screen',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot<NoteModel>>(
          stream: FirebaseFireStoreController().read(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  return ListTile(
                    onTap: () {
                      navigatorToUpdateScreen(snapshot, index);
                    },
                    title: Text(snapshot.data!.docs[index].data().title),
                    subtitle: Text(snapshot.data!.docs[index].data().info),
                    leading: const Icon(Icons.note),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () async =>
                          _delete(id: snapshot.data!.docs[index].id),
                    ),
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.warning_amber,
                        color: Colors.red,
                      ),
                      SizedBox(height: 10),
                      Text("you don't have any data ..!"),
                    ],
                  );
                }
              },
            );
          }),
    );
  }

  Future<void> _delete({required String id}) async {
    bool status = await FirebaseFireStoreController().delete(path: id);
    String message =
        status ? 'Note Deleted Successfully' : 'Note Deleted Failed!';
    showSnackBar(context, message: message, error: !status);
  }

  void navigatorToUpdateScreen(
    AsyncSnapshot<QuerySnapshot<NoteModel>> snapshot,
    int index,
  ) {
    QueryDocumentSnapshot<NoteModel> queryDocumentSnapshot =
        snapshot.data!.docs[index];
    NoteModel noteModel = queryDocumentSnapshot.data();
    noteModel.id = queryDocumentSnapshot.id;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotesScreen(noteModel: noteModel),
        ));
  }
}
