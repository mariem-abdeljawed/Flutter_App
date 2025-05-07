class BudgetGoal {
  final int? id;
  final String category;
  final double amount;
  final int month;
  final int year;

  BudgetGoal({
    this.id,
    required this.category,
    required this.amount,
    required this.month,
    required this.year,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'month': month,
      'year': year,
    };
  }

  factory BudgetGoal.fromMap(Map<String, dynamic> map) {
    return BudgetGoal(
      id: map['id'],
      category: map['category'],
      amount: map['amount'],
      month: map['month'],
      year: map['year'],
    );
  }
}