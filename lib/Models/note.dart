const String tableName = 'Notes';

class Note {
  final int? id;
  final String? title;
  final String? description;
  Note({
    this.id,
    this.title,
    this.description,
  });
  Note copy({
    int? id,
    String? title,
    String? description,
  }) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
      );
  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.title: title,
        NoteFields.description: description,
      };
  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NoteFields.id] as int?,
        title: json[NoteFields.title] as String?,
        description: json[NoteFields.description] as String?,
      );
}

class NoteFields {
  static final List<String> values = [
    id,
    title,
    description,
  ];
  static const String id = '_id';
  static const String title = '_title';
  static const String description = '_description';
}
