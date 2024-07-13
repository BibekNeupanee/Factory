import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatters

class AddOrderPage extends StatefulWidget {
  @override
  _AddOrderPageState createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  List<String> _sizes = [
    "S/M",
    "M/L",
    "L/XL",
    "S",
    "M",
    "L",
    "XL",
    "2XL",
    "3XL",
    "4XL",
    "5XL"
  ];

  TextEditingController _customerController = TextEditingController();
  TextEditingController _productController = TextEditingController();
  TextEditingController _codeController = TextEditingController();

  List<Entry> _entries = [];
  List<Order> _orders = [];

  void _addNewEntry() {
    setState(() {
      _entries.add(Entry(
        sizeController: TextEditingController(),
        colorController: TextEditingController(),
        quantityController: TextEditingController(),
      ));
    });
  }

  void _addOrder() {
    print("Adding order with entries:");
    _entries.forEach((entry) {
      print(
          "Size: ${entry.sizeController.text}, Color: ${entry.colorController.text}, Quantity: ${entry.quantityController.text}");
    });

    setState(() {
      _orders.add(Order(
          customer: _customerController.text,
          product: _productController.text,
          code: _codeController.text,
          entries: List.from(_entries)));

      // Clear fields after adding to list
      _customerController.clear();
      _productController.clear();
      _codeController.clear();
      _entries.clear(); // Only clear entries after adding to list
    });
  }

  Widget _buildEntryField(Entry entry) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'Size'),
            items: _sizes.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              entry.sizeController.text = newValue ?? '';
            },
            value: entry.sizeController.text.isEmpty
                ? null
                : entry.sizeController.text,
          ),
        ),
        Expanded(
          child: TextField(
            controller: entry.colorController,
            decoration: InputDecoration(labelText: 'Color'),
          ),
        ),
        Expanded(
          child: TextField(
            controller: entry.quantityController,
            keyboardType: TextInputType.numberWithOptions(decimal: false),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(labelText: 'Quantity'),
          ),
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            setState(() => _entries.remove(entry));
            entry.sizeController.dispose();
            entry.colorController.dispose();
            entry.quantityController.dispose();
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _customerController,
            decoration: InputDecoration(labelText: 'Customer Name'),
          ),
          TextField(
            controller: _productController,
            decoration: InputDecoration(labelText: 'Product Name'),
          ),
          TextField(
            controller: _codeController,
            decoration: InputDecoration(labelText: 'Code'),
          ),
          SizedBox(height: 20),
          ..._entries.map((entry) => _buildEntryField(entry)).toList(),
          ElevatedButton(
            onPressed: _addNewEntry,
            child: Text('Add New Size/Color/Quantity'),
          ),
          ElevatedButton(
            onPressed: _addOrder,
            child: Text('Add Order'),
          ),
          SizedBox(height: 20),
          ..._orders.map((order) => Text(
              "Customer: ${order.customer}\nProduct: ${order.product}\nCode: ${order.code}\nEntries: ${order.entries.map((e) => 'Size: ${e.sizeController.text}, Color: ${e.colorController.text}, Quantity: ${e.quantityController.text}').join(', ')}")),
        ],
      ),
    );
  }
}

class Entry {
  TextEditingController sizeController;
  TextEditingController colorController;
  TextEditingController quantityController;

  Entry(
      {required this.sizeController,
      required this.colorController,
      required this.quantityController});
}

class Order {
  String customer;
  String product;
  String code;
  List<Entry> entries;

  Order(
      {required this.customer,
      required this.product,
      required this.code,
      required this.entries});
}
