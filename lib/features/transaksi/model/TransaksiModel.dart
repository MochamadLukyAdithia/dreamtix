class Transaction {
  final String title;
  final String date;
  final String imageUrl;
  final String status;
  final String? transactionId;
  final String? total;

  Transaction(this.title, this.date, this.imageUrl, this.status, this.transactionId, this.total);
}
