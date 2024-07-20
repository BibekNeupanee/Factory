import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_amount.dart';

class LedgerEntry {
  final DateTime date;
  final String particular;
  double debit; // Previously work as debit
  double credit; // Previously cash as credit
  double total; // Running total accumulated

  LedgerEntry({
    required this.date,
    required this.particular,
    required this.debit,
    required this.credit,
    this.total = 0.0,
  });
}

class LedgerPage extends StatefulWidget {
  @override
  _LedgerPageState createState() => _LedgerPageState();
}

class _LedgerPageState extends State<LedgerPage> {
  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFromDate
          ? (fromDate ?? DateTime.now())
          : (toDate ?? fromDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: isFromDate
          ? DateTime(2101)
          : (fromDate?.add(Duration(days: 30)) ?? DateTime.now()),
    );
    if (picked != null &&
        (isFromDate ? picked != fromDate : picked != toDate)) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
          toDate = null;
        } else {
          toDate = picked;
        }
      });
    }
  }

  List<LedgerEntry> entries = [];
  List<LedgerEntry> filteredEntries = [];
  DateTime? fromDate;
  DateTime? toDate;
  double cumulativeTotal = 0.0;

  @override
  void initState() {
    super.initState();
    entries = List.generate(15, (index) {
      DateTime date = DateTime.now().subtract(Duration(days: index * 2));
      return LedgerEntry(
        date: date,
        particular: 'Transaction ${index + 1}',
        debit: (index % 3 == 0) ? (index * 1000).toDouble() : 0.0,
        credit: (index % 3 != 0) ? (index * 1000).toDouble() : 0.0,
      );
    });
    _calculateTotals();
  }

  void _calculateTotals() {
    double runningTotal = 0;
    entries.forEach((entry) {
      runningTotal += entry.debit - entry.credit;
      entry.total = runningTotal;
    });
    cumulativeTotal = runningTotal;
    filteredEntries = List.from(entries);
  }

  void _filterEntries() {
    setState(() {
      filteredEntries = entries
          .where((entry) =>
              (fromDate == null ||
                  entry.date.isAfter(fromDate!.subtract(Duration(days: 1)))) &&
              (toDate == null ||
                  entry.date.isBefore(toDate!.add(Duration(days: 1)))))
          .toList();
      _calculateFilteredTotals();
    });
  }

  void _calculateFilteredTotals() {
    double runningTotal = 0;
    filteredEntries.forEach((entry) {
      runningTotal += entry.debit - entry.credit;
      entry.total = runningTotal;
    });
    cumulativeTotal = runningTotal;
  }

  void _editCredit(LedgerEntry entry) async {
    TextEditingController _controller =
        TextEditingController(text: entry.credit.toString());
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Edit Credit for ${entry.particular}"),
            content: TextField(
              controller: _controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: "Credit Amount"),
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
                  setState(() {
                    entry.credit = double.parse(_controller.text);
                    _calculateTotals(); // Recalculate totals after editing
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _showAddEntryDialog() async {
    final newEntry = await showDialog<LedgerEntry>(
      context: context,
      builder: (context) => AddAmountPage(),
    );

    if (newEntry != null) {
      setState(() {
        entries.add(newEntry);
        _calculateTotals();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ledger Details"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddEntryDialog,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Search',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    onTap: () => _selectDate(context, true),
                    controller: TextEditingController(
                        text: fromDate == null
                            ? ''
                            : DateFormat('yyyy-MM-dd').format(fromDate!)),
                    decoration: InputDecoration(
                        labelText: 'From',
                        suffixIcon: Icon(Icons.calendar_today)),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    onTap: () => _selectDate(context, false),
                    controller: TextEditingController(
                        text: toDate == null
                            ? ''
                            : DateFormat('yyyy-MM-dd').format(toDate!)),
                    decoration: InputDecoration(
                        labelText: 'To',
                        suffixIcon: Icon(Icons.calendar_today)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: _filterEntries,
              child: Text('Search'),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Particular')),
                    DataColumn(label: Text('Debit (Work)')),
                    DataColumn(label: Text('Credit (Cash)')),
                    DataColumn(label: Text('Total')),
                  ],
                  rows: filteredEntries
                      .map((entry) => DataRow(cells: [
                            DataCell(Text(
                                DateFormat('yyyy-MM-dd').format(entry.date))),
                            DataCell(Text(entry.particular)),
                            DataCell(Text('${entry.debit.toStringAsFixed(2)}')),
                            DataCell(
                              Text('${entry.credit.toStringAsFixed(2)}'),
                              onTap: () => _editCredit(entry),
                            ),
                            DataCell(Text('${entry.total.toStringAsFixed(2)}')),
                          ]))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}