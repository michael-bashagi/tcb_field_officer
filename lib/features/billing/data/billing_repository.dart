import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PaymentStatus { completed, pending, failed }

class PaymentTransaction {
  final String transactionId;
  final String title;
  final double amount;
  final DateTime date;
  final PaymentStatus status;
  final String paymentMethod;

  const PaymentTransaction({
    required this.transactionId,
    required this.title,
    required this.amount,
    required this.date,
    required this.status,
    required this.paymentMethod,
  });

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) {
    return PaymentTransaction(
      transactionId: json['transactionId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      date: json['date'] != null
          ? DateTime.tryParse(json['date'] as String) ?? DateTime.now()
          : DateTime.now(),
      status: PaymentStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String? ?? 'pending'),
        orElse: () => PaymentStatus.pending,
      ),
      paymentMethod: json['paymentMethod'] as String? ?? 'Mobile Money',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'status': status.name,
      'paymentMethod': paymentMethod,
    };
  }
}

class SubscriptionInfo {
  final String planName;
  final bool isActive;
  final DateTime renewalDate;
  final double monthlyCost;

  const SubscriptionInfo({
    required this.planName,
    required this.isActive,
    required this.renewalDate,
    required this.monthlyCost,
  });
}

abstract class BillingRepository {
  Future<SubscriptionInfo> getCurrentSubscription();
  Future<List<PaymentTransaction>> getTransactionHistory();
  Future<bool> initiateMobilePayment({
    required String phoneNumber,
    required double amount,
    required String description,
    required String provider,
  });
}

class DemoBillingRepository implements BillingRepository {
  @override
  Future<SubscriptionInfo> getCurrentSubscription() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return SubscriptionInfo(
      planName: 'Field Officer Enterprise',
      isActive: true,
      renewalDate: DateTime.now().add(const Duration(days: 28)),
      monthlyCost: 45000.0,
    );
  }

  @override
  Future<List<PaymentTransaction>> getTransactionHistory() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      PaymentTransaction(
        transactionId: 'TXN-984214',
        title: 'Monthly Agent License Renewal',
        amount: 45000.0,
        date: DateTime.now().subtract(const Duration(days: 2)),
        status: PaymentStatus.completed,
        paymentMethod: 'M-Pesa',
      ),
      PaymentTransaction(
        transactionId: 'TXN-872311',
        title: 'GPS Surveying Tool Access Fee',
        amount: 15000.0,
        date: DateTime.now().subtract(const Duration(days: 15)),
        status: PaymentStatus.completed,
        paymentMethod: 'Tigo Pesa',
      ),
      PaymentTransaction(
        transactionId: 'TXN-742109',
        title: 'Bulk SMS Weather Alert Package',
        amount: 25000.0,
        date: DateTime.now().subtract(const Duration(days: 34)),
        status: PaymentStatus.completed,
        paymentMethod: 'Airtel Money',
      ),
    ];
  }

  @override
  Future<bool> initiateMobilePayment({
    required String phoneNumber,
    required double amount,
    required String description,
    required String provider,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }
}

final billingRepositoryProvider = Provider<BillingRepository>((ref) {
  return DemoBillingRepository();
});
