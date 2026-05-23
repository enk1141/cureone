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
    _records.addAll([
      PaymentRecord(
        transactionId: 'TXN175846512345',
        date: DateTime(2025, 5, 22, 10, 25),
        method: 'UPI',
        bills: const [
          {
            'id': 'ELE-98723',
            'name': 'Electricity Bill',
            'category': 'electricity',
            'amount': 2450.00,
          },
          {
            'id': 'CAN-88294',
            'name': 'Water Bill',
            'category': 'hmwssb',
            'amount': 620.00,
          }
        ],
        amount: 3070.00,
        status: 'Success',
      ),
      PaymentRecord(
        transactionId: 'TXN1700987654',
        date: DateTime(2025, 5, 15, 11, 30),
        method: 'UPI',
        bills: const [
          {
            'id': 'CAN-88294',
            'name': 'Home Water Connection',
            'category': 'hmwssb',
            'amount': 620.00,
          }
        ],
        amount: 620.00,
        status: 'Success',
      ),
      PaymentRecord(
        transactionId: 'TXN1700654321',
        date: DateTime(2025, 5, 10, 14, 15),
        method: 'UPI',
        bills: const [
          {
            'id': 'ELE-98723',
            'name': 'Main Residence',
            'category': 'electricity',
            'amount': 2450.00,
          }
        ],
        amount: 2450.00,
        status: 'Success',
      ),
      PaymentRecord(
        transactionId: 'TXN1700111111',
        date: DateTime(2025, 5, 2, 9, 45),
        method: 'UPI',
        bills: const [
          {
            'id': 'CHL-10293',
            'name': 'Speeding Challan',
            'category': 'echallan',
            'amount': 225.00,
          }
        ],
        amount: 225.00,
        status: 'Success',
      ),
      PaymentRecord(
        transactionId: 'TXN1700222222',
        date: DateTime(2025, 4, 20, 16, 20),
        method: 'UPI',
        bills: const [
          {
            'id': 'PTX-99821',
            'name': 'Plot A - Jubilee Hills',
            'category': 'property_tax',
            'amount': 2400.00,
          }
        ],
        amount: 2400.00,
        status: 'Success',
      ),
      PaymentRecord(
        transactionId: 'TXN1700333333',
        date: DateTime(2025, 4, 12, 18, 10),
        method: 'UPI',
        bills: const [
          {
            'id': 'CHL-99821',
            'name': 'No Parking Challan',
            'category': 'echallan',
            'amount': 150.00,
          }
        ],
        amount: 150.00,
        status: 'Failed',
      ),
      PaymentRecord(
        transactionId: 'TXN1700444444',
        date: DateTime(2025, 3, 28, 12, 0),
        method: 'Net Banking',
        bills: const [
          {
            'id': 'CAN-88294',
            'name': 'Water Bill Duplicate',
            'category': 'hmwssb',
            'amount': 500.00,
          }
        ],
        amount: 500.00,
        status: 'Refund',
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
