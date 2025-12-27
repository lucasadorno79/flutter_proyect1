class TransactionModel {
  final int? id;
  final double amount;
  final String category; // fijo, ahorro, variable, emergencia
  final String type; // income | expense
  final String date; // yyyy-MM-dd
  final String description;

  TransactionModel({
    this.id,
    required this.amount,
    required this.category,
    required this.type,
    required this.date,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'type': type,
      'date': date,
      'description': description,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      amount: map['amount'],
      category: map['category'],
      type: map['type'],
      date: map['date'],
      description: map['description'],
    );
  }
}
