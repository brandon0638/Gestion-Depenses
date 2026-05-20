class Transaction {
  final int id;
  final String type;
  final double amount;
  final String category;
  final String description;
  final DateTime date;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'amount': amount,
    'category': category,
    'description': description,
    'date': date.toIso8601String(),
  };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'],
    type: json['type'],
    amount: json['amount'],
    category: json['category'],
    description: json['description'],
    date: DateTime.parse(json['date']),
  );
}