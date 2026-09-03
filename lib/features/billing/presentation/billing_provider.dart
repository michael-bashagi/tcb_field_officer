import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/billing_repository.dart';

class BillingState {
  final SubscriptionInfo? subscription;
  final List<PaymentTransaction> transactions;
  final bool isLoading;
  final bool isProcessingPayment;
  final String? errorMessage;
  final String? successMessage;

  const BillingState({
    this.subscription,
    this.transactions = const [],
    this.isLoading = false,
    this.isProcessingPayment = false,
    this.errorMessage,
    this.successMessage,
  });

  BillingState copyWith({
    SubscriptionInfo? subscription,
    List<PaymentTransaction>? transactions,
    bool? isLoading,
    bool? isProcessingPayment,
    String? errorMessage,
    String? successMessage,
  }) {
    return BillingState(
      subscription: subscription ?? this.subscription,
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      isProcessingPayment: isProcessingPayment ?? this.isProcessingPayment,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

class BillingNotifier extends StateNotifier<BillingState> {
  final BillingRepository _repository;

  BillingNotifier(this._repository) : super(const BillingState()) {
    loadBillingData();
  }

  Future<void> loadBillingData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final subscription = await _repository.getCurrentSubscription();
      final transactions = await _repository.getTransactionHistory();
      state = state.copyWith(
        subscription: subscription,
        transactions: transactions,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to load billing information. Please try again.',
      );
    }
  }

  Future<bool> processMobilePayment({
    required String phoneNumber,
    required double amount,
    required String description,
    required String provider,
  }) async {
    state = state.copyWith(isProcessingPayment: true, errorMessage: null);
    try {
      final success = await _repository.initiateMobilePayment(
        phoneNumber: phoneNumber,
        amount: amount,
        description: description,
        provider: provider,
      );

      if (success) {
        state = state.copyWith(
          isProcessingPayment: false,
          successMessage: 'Payment prompt sent to $phoneNumber via $provider',
        );
        await loadBillingData();
        return true;
      } else {
        state = state.copyWith(
          isProcessingPayment: false,
          errorMessage: 'Payment initiation failed. Please try again.',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isProcessingPayment: false,
        errorMessage: 'We couldn\'t process this payment. Please try again.',
      );
      return false;
    }
  }

  void clearMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }
}

final billingNotifierProvider =
    StateNotifierProvider<BillingNotifier, BillingState>((ref) {
  final repository = ref.watch(billingRepositoryProvider);
  return BillingNotifier(repository);
});
