class Transaction {
  final int? id;
  final double amount;
  final String category;
  final String type;
  final String date;
  final String? description;

  Transaction({
    this.id,
    required this.amount,
    required this.category,
    required this.type,
    required this.date,
    this.description,
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

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as int?,
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      category: map['category'] as String? ?? '',
      type: map['type'] as String? ?? '',
      date: map['date'] as String? ?? '',
      description: map['description'] as String?,
    );
  }
}