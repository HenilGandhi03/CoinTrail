import 'package:cointrail/data/hive/boxes.dart';
import 'package:cointrail/data/models/transaction_model.dart';

class TransactionRepository {
  final _box = HiveBoxes.transactions();

  // CREATE
  Future<void> add(TransactionModel transaction) async {
    await _box.put(transaction.id, transaction);
  }

  List<TransactionModel> getAllSorted() {
    final list = _box.values.toList();
    list.sort((a, b) => b.date.compareTo(a.date)); // newest first
    return list;
  }

  List<TransactionModel> getRecent({int limit = 5}) {
    final all = getAllSorted();
    return all.take(limit).toList();
  }

  // // READ
  // List<TransactionModel> getAll() {
  //   return _box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  // }

  // DELETE
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  // CLEAR (optional)
  Future<void> clear() async {
    await _box.clear();
  }
}
