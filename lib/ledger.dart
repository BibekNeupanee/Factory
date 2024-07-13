import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LedgerEntry {
  final DateTime date;
  final String particular;
  final double credit; // Credit (previously work)
  final double debit; // Debit (previously cash)
  double total; // This will be calculated as running total

  LedgerEntry(
      {required this.date,
      required this.particular,
      required this.credit,
      required this.debit,
      this.total = 0.0});
}

class LedgerPage extends StatefulWidget {
  @override
  _LedgerPageState createState() => _LedgerPageState();
}

class _LedgerPageState extends State<LedgerPage> {
  List<LedgerEntry> entries = [];
  List<LedgerEntry> filteredEntries = [];
  DateTime? fromDate;
  DateTime? toDate;
  double cumulativeTotal = 0.0;

  @override
  void initState() {
    super.initState();
    entries = List.generate(15, (index) {
      DateTime date = DateTime.now().subtract(
          Duration(days: index * 2)); // Generates dates within the last 30 days
      return LedgerEntry(
        date: date,
        particular: 'Transaction ${index + 1}',
        credit: (index % 3 == 0) ? (index * 1000).toDouble() : 0.0,
        // Work as credit
        debit:
            (index % 3 != 0) ? (index * 1000).toDouble() : 0.0, // Cash as debit
      );
    });
    _calculateTotals();
    _filterEntries(); // Initialize filteredEntries
  }

  void _calculateTotals() {
    double runningTotal = 0;
    for (LedgerEntry entry in entries) {
      double net = entry.credit - entry.debit;
      runningTotal += net;
      entry.total = runningTotal;
    }
    cumulativeTotal = runningTotal; // Calculate the cumulative total
  }

  void _filterEntries() {
    setState(() {
      filteredEntries = entries.where((entry) {
        if (fromDate != null && entry.date.isBefore(fromDate!)) {
          return false;
        }
        if (toDate != null && entry.date.isAfter(toDate!)) {
          return false;
        }
        return true;
      }).toList();
      _calculateFilteredTotals();
    });
  }

  void _calculateFilteredTotals() {
    double runningTotal = 0;
    for (LedgerEntry entry in filteredEntries) {
      double net = entry.credit - entry.debit;
      runningTotal += net;
      entry.total = runningTotal;
    }
    cumulativeTotal = runningTotal; // Calculate the cumulative total
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    DateTime initialDate =
        isFromDate ? (fromDate ?? DateTime.now()) : (toDate ?? DateTime.now());
    DateTime firstDate =
        isFromDate ? DateTime(2000) : (fromDate ?? DateTime(2000));
    DateTime lastDate = isFromDate
        ? DateTime(2101)
        : (fromDate?.add(Duration(days: 30)) ?? DateTime(2101));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
          // Adjust the toDate if it is beyond the 30 days interval from fromDate
          if (toDate != null &&
              toDate!.isAfter(fromDate!.add(Duration(days: 30)))) {
            toDate = fromDate!.add(Duration(days: 30));
          }
        } else {
          toDate = picked;
          // Adjust the fromDate if it is beyond the 30 days interval from toDate
          if (fromDate != null &&
              fromDate!.isBefore(toDate!.subtract(Duration(days: 30)))) {
            fromDate = toDate!.subtract(Duration(days: 30));
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ledger Details"),
      ),
      body: Column(
        children: [
          // Search text
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Search',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          // Date pickers
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    onTap: () => _selectDate(context, true),
                    controller: TextEditingController(
                      text: fromDate == null
                          ? ''
                          : DateFormat('yyyy-MM-dd').format(fromDate!),
                    ),
                    decoration: InputDecoration(
                      labelText: 'From',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
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
                          : DateFormat('yyyy-MM-dd').format(toDate!),
                    ),
                    decoration: InputDecoration(
                      labelText: 'To',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Search button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: _filterEntries,
                child: Text('Search'),
              ),
            ),
          ),
          // Ledger of text
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Ledger of',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Fixed header
          Container(
            color: Colors.grey[200],
            child: Row(
              children: const [
                Expanded(
                  flex: 2,
                  child: Text('Date',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 3,
                  child: Text('Particular',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Credit (Work)',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Debit (Cash)',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Total',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
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
                    DataColumn(label: Text('Credit (Work)')),
                    DataColumn(label: Text('Debit (Cash)')),
                    DataColumn(label: Text('Total')),
                  ],
                  rows: [
                    ...filteredEntries.map((entry) {
                      return DataRow(cells: [
                        DataCell(
                            Text(DateFormat('yyyy-MM-dd').format(entry.date))),
                        DataCell(Text(entry.particular)),
                        DataCell(Text('${entry.credit.toStringAsFixed(2)}')),
                        DataCell(Text('${entry.debit.toStringAsFixed(2)}')),
                        DataCell(Text('${entry.total.toStringAsFixed(2)}')),
                      ]);
                    }).toList(),
                    DataRow(cells: [
                      DataCell(Text('')),
                      DataCell(Text('')),
                      DataCell(Text('')),
                      DataCell(Text('Sum:',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(Text('${cumulativeTotal.toStringAsFixed(2)}',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
