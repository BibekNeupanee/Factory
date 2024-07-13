import 'package:flutter/material.dart';

class LedgerPage extends StatelessWidget {
  final String staffName;

  LedgerPage({required this.staffName});

  @override
  Widget build(BuildContext context) {
    // Replace with your ledger display UI
    return Scaffold(
      appBar: AppBar(
        title: Text('Ledger for $staffName'),
      ),
      body: Center(
        child: Text('Ledger details for $staffName will be displayed here.'),
      ),
    );
  }
}
