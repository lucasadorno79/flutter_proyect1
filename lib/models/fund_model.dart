class FundModel {
  final int? id;
  final String name;
  final double balance;

  FundModel({
    this.id,
    required this.name,
    required this.balance,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
    };
  }

  factory FundModel.fromMap(Map<String, dynamic> map) {
    return FundModel(
      id: map['id'],
      name: map['name'],
      balance: map['balance'],
    );
  }
}
