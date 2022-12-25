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
      appBar: AppBar(
        title: const Text('Notes'),
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
                  ? const Center(
                      child: Text("you dont't have any notes for show"),
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
                          child: Card(
                            child: Column(
                              children: [
                                Text(notes[index].title!),
                              ],
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
