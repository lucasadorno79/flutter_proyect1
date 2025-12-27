class CalendarEvent {
  final int? id;
  final String title;
  final String date;

  CalendarEvent({
    this.id,
    required this.title,
    required this.date,
  });

  /// Convertir el objeto a Map (para SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
    };
  }

  /// Crear objeto desde SQLite
  factory CalendarEvent.fromMap(Map<String, dynamic> map) {
    return CalendarEvent(
      id: map['id'],
      title: map['title'],
      date: map['date'],
    );
  }
}