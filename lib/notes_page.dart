import 'package:flutter/material.dart';
import 'package:notesapp/model/note_database.dart';
import 'package:provider/provider.dart';

import 'model/note.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    readNote();
  }

  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              context.read<NoteDatabase>().addNote(textController.text);
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }

  void readNote() {
    context.read<NoteDatabase>().fetchNotes();
  }

  void updateNote(Note note) {
    textController.text = note.text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Note"),
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              context
                  .read<NoteDatabase>()
                  .updateNotes(note.id, textController.text);
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteDataBase = context.watch<NoteDatabase>();
    List<Note> currentNotes = noteDataBase.currentNotes;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes App"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: currentNotes.length,
            itemBuilder: (context, index) {
              final note = currentNotes[index];
              return ListTile(
                title: Text(note.text),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min, // Important for layout
                  children: [
                    IconButton(
                      onPressed: () => updateNote(note),
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () => deleteNote(note.id),
                      icon: Icon(Icons.dangerous),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
