import 'package:flutter/material.dart';
import 'dart:math';

class AddProductDialog extends StatefulWidget {
  final List<Map<String, String>> productDetails;
  final Function(Map<String, String>) addProductCallback;

  AddProductDialog({required this.productDetails, required this.addProductCallback});

  @override
  _AddProductDialogState createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> _sizes = [
    "S/M", "M/L", "L/XL", "S", "M", "L", "XL", "2XL", "3XL", "4XL", "5XL"
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Product'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _customerController.text.isEmpty ? null : _customerController.text,
              decoration: InputDecoration(
                labelText: 'Customer',
              ),
              items: widget.productDetails.map((product) {
                return DropdownMenuItem<String>(
                  value: product['customer'],
                  child: Text(product['customer']!),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _customerController.text = newValue!;
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
              value: _productController.text.isEmpty ? null : _productController.text,
              decoration: InputDecoration(
                labelText: 'Product',
              ),
              items: widget.productDetails.map((product) {
                return DropdownMenuItem<String>(
                  value: product['product'],
                  child: Text(product['product']!),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _productController.text = newValue!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a product';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _codeController,
              decoration: InputDecoration(labelText: 'Code'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter product code';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _colorController,
              decoration: InputDecoration(labelText: 'Color'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter product color';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _sizes[0],
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
                // Handle size selection if needed
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
              final newProduct = {
                'customer': _customerController.text,
                'product': _productController.text,
                'code': _codeController.text,
                'color': _colorController.text,
                'size': _sizes[0],
                'quantity': _quantityController.text,
                'date': DateTime.now().toString().split(' ')[0],
              };
              widget.addProductCallback(newProduct);
              _customerController.clear();
              _productController.clear();
              _codeController.clear();
              _colorController.clear();
              _quantityController.clear();
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
