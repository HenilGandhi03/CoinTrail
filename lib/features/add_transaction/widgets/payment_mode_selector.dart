// import 'package:cointrail/data/models/transaction_model.dart';
// import 'package:flutter/material.dart';
// import 'action_field.dart';

// class PaymentModeField extends StatelessWidget {
//   final PaymentMode selected;
//   final VoidCallback onTap;

//   const PaymentModeField({
//     super.key,
//     required this.selected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ActionField(
//       label: 'Payment',
//       leading: const Icon(Icons.credit_card),
//       value: _label(selected),
//       onTap: onTap,
//     );
//   }

//   String _label(PaymentMode mode) {
//     switch (mode) {
//       case PaymentMode.card:
//         return 'Credit Card';
//       case PaymentMode.cash:
//         return 'Cash';
//       case PaymentMode.upi:
//         return 'UPI';
//       default:
//         return mode.name;
//     }
//   }
// }
