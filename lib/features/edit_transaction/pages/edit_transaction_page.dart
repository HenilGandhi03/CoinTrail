// lib/features/edit_transaction/pages/edit_transaction_page.dart

import 'package:cointrail/data/models/transaction_model.dart';
import 'package:cointrail/data/repositories/category_repository.dart';
import 'package:cointrail/data/repositories/transaction_repository.dart';
import 'package:cointrail/features/add_transaction/controller/add_transaction_controller.dart';
import 'package:cointrail/features/add_transaction/pages/add_transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class EditTransactionPage extends StatelessWidget {
  const EditTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionModel transaction = Get.arguments as TransactionModel;

    return ChangeNotifierProvider(
      create: (_) => AddTransactionController(
        TransactionRepository(),
        CategoryRepository(),
        transaction, // edit mode
      ),
      child: const AddTransactionView(),
    );
  }
}
