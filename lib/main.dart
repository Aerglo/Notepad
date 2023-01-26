import 'package:flutter/material.dart';
import 'Models/note.dart';
import 'Database/note_database.dart';
import 'pages/view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyFirstPage(),
    );
  }
}

class MyFirstPage extends StatefulWidget {
  const MyFirstPage({super.key});

  @override
  State<MyFirstPage> createState() => _MyFirstPageState();
}

class _MyFirstPageState extends State<MyFirstPage> {
  late List<Note> notes;
  bool isLoading = false;
  @override
  void initState() {
    refreshNotes();
    super.initState();
  }

  Future refreshNotes() async {
    setState(() {
      isLoading = true;
    });
    NotesDatabases.instance.readAllNotes().then((value) => notes = value);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.yellow.shade600,
      ),
      body: FutureBuilder(
        future: NotesDatabases.instance.readAllNotes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return isLoading
              ? const CircularProgressIndicator()
              : notes.isEmpty
                  ? Center(
                      child: Text(
                        "you dont't have any notes for show",
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 18,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => UpdateNote(
                                  notes: notes[index],
                                ),
                              ),
                            );
                            refreshNotes();
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              8.0,
                              6.0,
                              8.0,
                              0,
                            ),
                            child: Card(
                              color: Colors.grey.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 3,
                              child: ListTile(
                                title: Text(notes[index].title!),
                                subtitle: Text(
                                  notes[index].description!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: notes.length,
                    );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const UpdateNote(),
            ),
          );
          refreshNotes();
        },
        backgroundColor: Colors.yellow.shade600,
        child: const Icon(
          Icons.add,
          color: Colors.black87,
        ),
      ),
    );
  }
}
