// edit_product.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditProductDialog extends StatefulWidget {
  final Map<String, String> product;
  final Function(Map<String, String>) editProductCallback;

  EditProductDialog({
    required this.product,
    required this.editProductCallback,
  });

  @override
  _EditProductDialogState createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  final _editCustomerController = TextEditingController();
  final _editProductController = TextEditingController();
  final _editCodeController = TextEditingController();
  final _editColorController = TextEditingController();
  final _editSizeController = TextEditingController();
  final _editQuantityController = TextEditingController();

  final GlobalKey<FormState> _editFormKey = GlobalKey<FormState>();

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
    _populateFields();
  }

  void _populateFields() {
    _editCustomerController.text = widget.product['customer']!;
    _editProductController.text = widget.product['product']!;
    _editCodeController.text = widget.product['code']!;
    _editColorController.text = widget.product['color']!;
    _editSizeController.text = widget.product['size']!;
    _editQuantityController.text = widget.product['quantity']!;
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
              TextFormField(
                controller: _editCustomerController,
                decoration: InputDecoration(labelText: 'Customer'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _editProductController,
                decoration: InputDecoration(labelText: 'Product'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _editCodeController,
                decoration: InputDecoration(labelText: 'Code'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product code';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _editColorController,
                decoration: InputDecoration(labelText: 'Color'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product color';
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
                    return 'Please enter product quantity';
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
              });
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
