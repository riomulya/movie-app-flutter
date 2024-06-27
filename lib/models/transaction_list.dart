class Transaction {
  final String id;
  final String email;
  final int grossAmount;
  final int orderId;
  final int quantity;
  final List<String> seat;

  Transaction({
    required this.id,
    required this.email,
    required this.grossAmount,
    required this.orderId,
    required this.quantity,
    required this.seat,
  });

  factory Transaction.fromJson(String id, Map<String, dynamic> json) {
    return Transaction(
      id: id,
      email: json['email'],
      grossAmount: json['grossAmount'],
      orderId: json['orderId'],
      quantity: json['quantity'],
      seat: List<String>.from(json['seat']),
    );
  }
}
