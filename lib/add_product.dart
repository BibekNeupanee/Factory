import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class AddProductDialog extends StatefulWidget {
  final List<Map<String, String>> productDetails;
  final Function(Map<String, String>) addProductCallback;

  AddProductDialog({
    required this.productDetails,
    required this.addProductCallback,
  });

  @override
  _AddProductDialogState createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();

  final _customerController = TextEditingController();
  final _productController = TextEditingController();
  final _codeController = TextEditingController();
  final _colorController = TextEditingController();
  final _sizeController = TextEditingController();
  final _quantityController = TextEditingController();
  final _dateController = TextEditingController();

  List<String> _customers = [];
  List<String> _products = [];
  List<String> _codes = [];
  List<String> _colors = [];
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

  @override
  void initState() {
    super.initState();
    _populateDropdownData();
  }

  void _populateDropdownData() {
    _customers = widget.productDetails
        .map((product) => product['customer']!)
        .toSet()
        .toList();
    _products = widget.productDetails
        .map((product) => product['product']!)
        .toSet()
        .toList();
    _codes = widget.productDetails
        .map((product) => product['code']!)
        .toSet()
        .toList();
    _colors = widget.productDetails
        .map((product) => product['color']!)
        .toSet()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Product'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Customer',
                ),
                items: _customers.map((customer) {
                  return DropdownMenuItem<String>(
                    value: customer,
                    child: Text(customer),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  _customerController.text = newValue!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a customer';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Product',
                ),
                items: _products.map((product) {
                  return DropdownMenuItem<String>(
                    value: product,
                    child: Text(product),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  _productController.text = newValue!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a product';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Code',
                ),
                items: _codes.map((code) {
                  return DropdownMenuItem<String>(
                    value: code,
                    child: Text(code),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  _codeController.text = newValue!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a code';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Color',
                ),
                items: _colors.map((color) {
                  return DropdownMenuItem<String>(
                    value: color,
                    child: Text(color),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  _colorController.text = newValue!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a color';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Size',
                ),
                items: _sizes.map((size) {
                  return DropdownMenuItem<String>(
                    value: size,
                    child: Text(size),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  _sizeController.text = newValue!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a size';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Manufactured Date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: _selectDate,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Add'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.addProductCallback({
                'customer': _customerController.text,
                'product': _productController.text,
                'code': _codeController.text,
                'color': _colorController.text,
                'size': _sizeController.text,
                'quantity': _quantityController.text,
                'date': _dateController.text,
              });
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
}
