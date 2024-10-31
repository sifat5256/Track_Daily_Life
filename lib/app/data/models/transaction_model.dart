class TransactionModel {
  final String id; // Unique identifier
  final String type; // 'Income' or 'Expense'
  final double amount;
  final String description;
  final DateTime dateTime;

  TransactionModel({
    required this.id, // Include id in the constructor
    required this.type,
    required this.amount,
    required this.description,
    required this.dateTime,
  }) {
    // Basic validation
    if (type != 'Income' && type != 'Expense') {
      throw ArgumentError('Type must be either "Income" or "Expense"');
    }
    if (amount <= 0) {
      throw ArgumentError('Amount must be greater than zero');
    }
    if (description.isEmpty) {
      throw ArgumentError('Description cannot be empty');
    }
  }

  // Convert JSON to TransactionModel
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'], // Get id from JSON
      type: json['type'],
      amount: json['amount'],
      description: json['description'],
      dateTime: DateTime.parse(json['dateTime']), // Parse dateTime from string
    );
  }

  // Convert TransactionModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id, // Include id in JSON output
      'type': type,
      'amount': amount,
      'description': description,
      'dateTime': dateTime.toIso8601String(), // Convert dateTime to ISO string
    };
  }

  // Equality and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TransactionModel && other.id == id; // Compare by id
  }

  @override
  int get hashCode => id.hashCode; // Use id for hashCode

  // Copy with method
  TransactionModel copyWith({
    String? type,
    double? amount,
    String? description,
    DateTime? dateTime,
    String? id, // Optionally change id in copyWith
  }) {
    return TransactionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
