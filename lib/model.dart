class TransactionModel {
  final int Amount;
  final DateTime date;
  final String type;
  final String note;
  TransactionModel({
    required this.Amount,
    required this.date,
    required this.type,
    required this.note,
  });
}
