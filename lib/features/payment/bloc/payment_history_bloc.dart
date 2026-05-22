/// Tiny in-memory registry for completed payments. Lives as a singleton so
/// the History tab can read it without us threading another bloc through every
/// route. Replace with a real bloc + repository once a backend is wired up.
class PaymentRecord {
  final String transactionId;
  final DateTime date;
  final String method;
  final List<Map<String, dynamic>> bills;
  final double amount;
  final String status; // 'Success' | 'Failed'

  PaymentRecord({
    required this.transactionId,
    required this.date,
    required this.method,
    required this.bills,
    required this.amount,
    this.status = 'Success',
  });
}

class PaymentHistoryRegistry {
  PaymentHistoryRegistry._() {
    // Seed with a few sample receipts so the History tab isn't empty on first launch.
    final now = DateTime.now();
    _records.addAll([
      PaymentRecord(
        transactionId: 'TXN1701234567',
        date: now.subtract(const Duration(days: 2)),
        method: 'UPI',
        bills: const [
          {
            'id': 'PTX-99821',
            'name': 'Plot A - Jubilee Hills',
            'category': 'property_tax',
            'amount': 3250.00,
          }
        ],
        amount: 3250.00,
      ),
      PaymentRecord(
        transactionId: 'TXN1700987654',
        date: now.subtract(const Duration(days: 5)),
        method: 'Net Banking',
        bills: const [
          {
            'id': 'CAN-88294',
            'name': 'Home Water Connection',
            'category': 'hmwssb',
            'amount': 1150.00,
          }
        ],
        amount: 1150.00,
      ),
      PaymentRecord(
        transactionId: 'TXN1700654321',
        date: now.subtract(const Duration(days: 14)),
        method: 'UPI',
        bills: const [
          {
            'id': 'ELE-98723',
            'name': 'Main Residence',
            'category': 'electricity',
            'amount': 2640.00,
          }
        ],
        amount: 2640.00,
      ),
    ]);
  }

  static final PaymentHistoryRegistry instance = PaymentHistoryRegistry._();
  final List<PaymentRecord> _records = [];

  List<PaymentRecord> get all =>
      List.unmodifiable(_records..sort((a, b) => b.date.compareTo(a.date)));

  void record({
    required List<Map<String, dynamic>> bills,
    required String transactionId,
    required String method,
  }) {
    final amount = bills.fold<double>(
      0.0,
      (sum, b) => sum + (b['amount'] as num).toDouble(),
    );
    _records.add(PaymentRecord(
      transactionId: transactionId,
      date: DateTime.now(),
      method: method,
      bills: List<Map<String, dynamic>>.from(bills),
      amount: amount,
    ));
  }
}
