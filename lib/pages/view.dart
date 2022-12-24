import 'package:flutter/material.dart';
import '../Models/note.dart';
import '../Database/note_database.dart';

class UpdateNote extends StatefulWidget {
  final Note? notes;
  const UpdateNote({super.key, this.notes});

  @override
  State<UpdateNote> createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  @override
  final _formkey = GlobalKey<FormState>();
  late String title;
  late String description;
  void initState() {
    title = widget.notes?.title ?? '';
    description = widget.notes?.description ?? '';
    super.initState();
  }

  void addOrUpdateNote() async {
    final isValid = _formkey.currentState!.validate();
    final isUpdating = widget.notes != null;
    if (isUpdating) {
      await updateNote();
    } else {
      await addNote();
    }
  }

  void deleteNote() async {
    if (widget.notes != null) {
      await delete();
    } else {
      return;
    }
  }

  Future delete() async {
    NotesDatabases.instance.deletNote(widget.notes!.id!);
  }

  Future updateNote() async {
    final note = widget.notes!.copy(
      title: title,
      description: description,
    );
    await NotesDatabases.instance.updateNote(note);
  }

  Future addNote() async {
    final note = Note(
      title: title,
      description: description,
    );
    await NotesDatabases.instance.create(note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add or Edit Note'),
      ),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
                validator: (title) => title != null && title.isEmpty
                    ? 'Value should not be empty'
                    : null,
                onChanged: (String title) {
                  setState(() {
                    this.title = title;
                  });
                },
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(
                  label: Text('Decription'),
                ),
                validator: (descripton) =>
                    description != null && description.isEmpty
                        ? 'Value should not be empty'
                        : null,
                onChanged: (String description) {
                  setState(() {
                    this.description = description;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      deleteNote();
                      Navigator.pop(context);
                    },
                    child: const Text('Delete'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      addOrUpdateNote();
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
