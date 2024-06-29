class Transaction {
  final String email;
  final int grossAmount;
  final int orderId;
  final int quantity;
  final List<String> seat;

  Transaction({
    required this.email,
    required this.grossAmount,
    required this.orderId,
    required this.quantity,
    required this.seat,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      email: json['email'],
      grossAmount: json['grossAmount'],
      orderId: json['orderId'],
      quantity: json['quantity'],
      seat: List<String>.from(json['seat']),
    );
  }
}
