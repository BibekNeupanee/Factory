import 'package:flutter/material.dart';
import 'ledger.dart';

class AddAmountPage extends StatefulWidget {
  @override
  _AddAmountPageState createState() => _AddAmountPageState();
}

class _AddAmountPageState extends State<AddAmountPage> {
  final TextEditingController cashController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add New Ledger Entry"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: TextEditingController(text: "cash"),
            decoration: InputDecoration(labelText: "Particulars"),
            readOnly: true,
          ),
          TextField(
            controller: cashController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: "Cash"),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text("Save"),
          onPressed: () {
            LedgerEntry newEntry = LedgerEntry(
              date: DateTime.now(), // Set to current date or choose date
              particular: "cash",
              debit: 0.0, // No debit amount
              credit: double.parse(cashController.text),
            );
            Navigator.of(context).pop(newEntry);
          },
        ),
      ],
    );
  }
}
