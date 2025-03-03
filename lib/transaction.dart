class Transaction {
  final String id;
  final String name;
  final int duration;
  final DateTime date;
  final String type;

  Transaction({
    required this.id,
    required this.name,
    required this.duration,
    required this.date,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'date': date.toIso8601String(),
      'type': type,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      name: map['name'],
      duration: map['duration'],
      date: DateTime.parse(map['date']),
      type: map['type'],
    );
  }
}
