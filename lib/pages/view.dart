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
  bool temp = false;
  final _formkey = GlobalKey<FormState>();
  late String title;
  late String description;

  @override
  void initState() {
    title = widget.notes?.title ?? '';
    description = widget.notes?.description ?? '';
    super.initState();
  }

  void addOrUpdateNote() async {
    final isValid = _formkey.currentState!.validate();
    final isUpdating = widget.notes != null;
    if (isValid) {
      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }
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
    bool isEditing = widget.notes == null;
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        title: const Text(
          'Add or Edit Note',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.yellow.shade600,
        automaticallyImplyLeading: false,
      ),
      body: isEditing || temp
          ? Form(
              key: _formkey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: title,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                        ),
                        decoration: InputDecoration(
                          label: Text(
                            'Title',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                            ),
                          ),
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
                      const SizedBox(height: 20),
                      TextFormField(
                        style: TextStyle(
                          color: Colors.grey.shade400,
                        ),
                        textAlignVertical: TextAlignVertical.top,
                        initialValue: description,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignLabelWithHint: true,
                          label: Text(
                            'Decription',
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                        ),
                        maxLines: 12,
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
                      const SizedBox(height: 20),
                      Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              deleteNote();
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              addOrUpdateNote();
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.save_outlined,
                              color: Colors.grey.shade400,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.notes!.title!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade400,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    widget.notes!.description!,
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      color: Colors.grey.shade400,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          deleteNote();
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            temp = true;
                          });
                        },
                        icon: Icon(
                          Icons.edit_outlined,
                          color: Colors.grey.shade400,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
