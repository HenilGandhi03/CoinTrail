import 'package:cointrail/data/hive/boxes.dart';
import 'package:cointrail/data/models/transaction_model.dart';

class TransactionRepository {
  final _box = HiveBoxes.transactions();

  /// CREATE / UPDATE
  Future<void> add(TransactionModel transaction) async {
    await _box.put(transaction.id, transaction);
  }

  /// READ
  List<TransactionModel> getAllSorted() {
    final list = _box.values.toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  List<TransactionModel> getRecent({int limit = 5}) {
    return getAllSorted().take(limit).toList();
  }

  /// DELETE
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  /// CLEAR (optional)
  Future<void> clear() async {
    await _box.clear();
  }
}
