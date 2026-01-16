import 'package:flutter/material.dart';

class PaymentModeInputField extends StatelessWidget {
  final TextEditingController controller;

  const PaymentModeInputField({super.key, required this.controller});

  static const double _fieldHeight = 56; // input height only

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔤 Label
        const Text('Payment Mode'),
        const SizedBox(height: 6),

        // 📝 Input (fixed height)
        SizedBox(
          height: _fieldHeight,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: 'Cash',
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
