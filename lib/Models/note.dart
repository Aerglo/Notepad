const String tableName = 'Notes';

class Note {
  final int? id;
  final String? title;
  final String? description;
  final String? direction;
  Note({
    this.id,
    this.title,
    this.description,
    this.direction,
  });
  Note copy({
    int? id,
    String? title,
    String? description,
    String? direction,
  }) =>
      Note(
          id: id ?? this.id,
          title: title ?? this.title,
          description: description ?? this.description,
          direction: direction ?? this.direction);
  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.title: title,
        NoteFields.description: description,
        NoteFields.direction: direction,
      };
  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NoteFields.id] as int?,
        title: json[NoteFields.title] as String?,
        description: json[NoteFields.description] as String?,
        direction: json[NoteFields.direction] as String?,
      );
}

class NoteFields {
  static final List<String> values = [
    id,
    title,
    description,
    direction,
  ];
  static const String id = '_id';
  static const String title = '_title';
  static const String description = '_description';
  static const String direction = '_direction';
}
