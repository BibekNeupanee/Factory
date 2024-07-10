// edit_product.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditProductDialog extends StatefulWidget {
  final Map<String, String> product;
  final List<Map<String, String>> productDetails;
  final Function(Map<String, String>) editProductCallback;

  EditProductDialog({
    required this.product,
    required this.productDetails,
    required this.editProductCallback,
  });

  @override
  _EditProductDialogState createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  final _editFormKey = GlobalKey<FormState>();

  final _editCustomerController = TextEditingController();
  final _editProductController = TextEditingController();
  final _editCodeController = TextEditingController();
  final _editColorController = TextEditingController();
  final _editSizeController = TextEditingController();
  final _editQuantityController = TextEditingController();
  final _editDateController = TextEditingController();

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
    _populateFields();
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

  void _populateFields() {
    _editCustomerController.text = widget.product['customer']!;
    _editProductController.text = widget.product['product']!;
    _editCodeController.text = widget.product['code']!;
    _editColorController.text = widget.product['color']!;
    _editSizeController.text = widget.product['size']!;
    _editQuantityController.text = widget.product['quantity']!;
    _editDateController.text = widget.product['date']!;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Product'),
      content: Form(
        key: _editFormKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _editCustomerController.text,
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
                  setState(() {
                    _editCustomerController.text = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a customer';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _editProductController.text,
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
                  setState(() {
                    _editProductController.text = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a product';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _editCodeController.text,
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
                  setState(() {
                    _editCodeController.text = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a code';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _editColorController.text,
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
                  setState(() {
                    _editColorController.text = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a color';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _editSizeController.text,
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
                  setState(() {
                    _editSizeController.text = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a size';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _editQuantityController,
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
                controller: _editDateController,
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
          child: Text('Save'),
          onPressed: () {
            if (_editFormKey.currentState!.validate()) {
              widget.editProductCallback({
                'customer': _editCustomerController.text,
                'product': _editProductController.text,
                'code': _editCodeController.text,
                'color': _editColorController.text,
                'size': _editSizeController.text,
                'quantity': _editQuantityController.text,
                'date': _editDateController.text,
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
        _editDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
}
