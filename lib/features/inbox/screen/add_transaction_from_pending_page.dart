import 'package:cointrail/data/models/pending_transaction_model.dart';
import 'package:cointrail/data/repositories/category_repository.dart';
import 'package:cointrail/data/repositories/transaction_repository.dart';
import 'package:cointrail/features/add_transaction/controller/add_transaction_controller.dart';
import 'package:cointrail/features/add_transaction/pages/add_transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTransactionFromPendingPage extends StatelessWidget {
  final PendingTransaction pending;

  const AddTransactionFromPendingPage({
    super.key,
    required this.pending,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddTransactionController.fromPending(
        TransactionRepository(),
        CategoryRepository(),
        pending,
      ),
      child: const AddTransactionView(),
    );
  }
}
