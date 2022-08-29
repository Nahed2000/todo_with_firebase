import 'package:firebase_course/firebase/firebase_firestore.dart';
import 'package:firebase_course/model/note_model.dart';
import 'package:firebase_course/utils/helper.dart';
import 'package:flutter/material.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key, this.noteModel}) : super(key: key);
  final NoteModel? noteModel;

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> with Helper {
  late TextEditingController titleController;
  late TextEditingController infoController;

  @override
  void initState() {
    // TODO: implement initState
    titleController = TextEditingController(text: widget.noteModel?.title);
    infoController = TextEditingController (text: widget.noteModel?.info);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    titleController.dispose();
    infoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          isNewNote() ? 'Create Note' : 'Update Note',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: const Icon(Icons.title)),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: infoController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Info',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              prefixIcon: const Icon(Icons.info_outline),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: ()async =>await _performSave(),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _performSave() async {
    if (checkData()) {
      await save();
    }
  }

  bool checkData() {
    if (titleController.text.isNotEmpty && infoController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(
      context,
      message: 'Required Data , Enter title and information',
      error: true,
    );
    return false;
  }

  Future<void> save() async {
    bool status = isNewNote()
        ? await FirebaseFireStoreController().create(noteModel: noteModel)
        : await FirebaseFireStoreController().update(noteModel: noteModel);
    String message = status ? 'Note Saved Successfully' : 'Note Saved Failed!';
    showSnackBar(context, message: message, error: !status);
    if (isNewNote()) {
      _clear();
    } else {
      Navigator.pop(context);
    }
  }

  void _clear() {
    titleController.text = '';
    infoController.text = '';
  }

  bool isNewNote() => widget.noteModel == null;

  NoteModel get noteModel {
    NoteModel noteModel = isNewNote() ? NoteModel() : widget.noteModel!;
    noteModel.title = titleController.text;
    noteModel.info = infoController.text;
    return noteModel;
  }
}
