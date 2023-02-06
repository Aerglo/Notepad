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
            color: Colors.white70,
          ),
        ),
        backgroundColor: Colors.teal.shade500,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: isEditing || temp
            ? Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          initialValue: title,
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                          decoration: const InputDecoration(
                            label: Text(
                              'Title',
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          validator: (title) => title != null && title.isEmpty
                              ? 'Title should not be empty'
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
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignLabelWithHint: true,
                            label: Text(
                              'Decription',
                              style: TextStyle(color: Colors.grey.shade400),
                            ),
                          ),
                          maxLines: 16,
                          validator: (description) =>
                              description != null && description.isEmpty
                                  ? 'Desciption should not be empty'
                                  : null,
                          onChanged: (String description) {
                            setState(() {
                              this.description = description;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.grey.shade800,
                                      title: Text(
                                        'Alert',
                                        style: TextStyle(
                                          color: Colors.teal.shade500,
                                        ),
                                      ),
                                      content: Text(
                                        'Are you sure?',
                                        style: TextStyle(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              color: Colors.teal.shade500,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            deleteNote();
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Yes',
                                            style: TextStyle(
                                              color: Colors.teal.shade500,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                bool isValid =
                                    _formkey.currentState!.validate();
                                if (isValid) {
                                  addOrUpdateNote();
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                          'Title and description should not be empty'),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                }
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
            : SingleChildScrollView(
                child: Padding(
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
                      SizedBox(
                        height: 40,
                        child: Center(
                          child: Divider(
                            color: Colors.teal.shade500,
                            thickness: 2,
                          ),
                        ),
                      ),
                      Text(
                        widget.notes!.description!,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.grey.shade800,
                                    title: Text(
                                      'Alert',
                                      style: TextStyle(
                                        color: Colors.teal.shade500,
                                      ),
                                    ),
                                    content: Text(
                                      'Are you sure?',
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                            color: Colors.teal.shade500,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          deleteNote();
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(
                                            color: Colors.teal.shade500,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
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
              ),
      ),
    );
  }
}
