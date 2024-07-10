// detail.dart

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'add_product.dart';
import 'edit_product.dart'; // Import EditProductDialog

class DetailPage extends StatefulWidget {
  final String name;

  DetailPage({required this.name});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<Map<String, String>> _productDetails = [
    {
      'customer': 'John Doe',
      'product': 'Tshirt',
      'code': 'Code1',
      'color': 'Blue',
      'size': 'M',
      'quantity': '50',
      'date': '2023-07-01'
    },
    {
      'customer': 'Jane Smith',
      'product': 'Trouser',
      'code': 'Code2',
      'color': 'Black',
      'size': 'L',
      'quantity': '30',
      'date': '2023-06-15'
    },
    {
      'customer': 'Alice Johnson',
      'product': 'Jeans',
      'code': 'Code3',
      'color': 'Blue',
      'size': 'XL',
      'quantity': '40',
      'date': '2023-06-20'
    },
  ];

  TextEditingController _searchProductController = TextEditingController();
  TextEditingController _searchCodeController = TextEditingController();
  List<Map<String, String>> _searchResults = [];
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details for ${widget.name}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _searchProductController,
                    decoration: InputDecoration(labelText: 'Search Product'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _searchCodeController,
                    decoration: InputDecoration(labelText: 'Search Code'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: _startDate == null
                        ? TextEditingController(text: '')
                        : TextEditingController(
                        text: DateFormat('yyyy-MM-dd').format(_startDate!)),
                    decoration: InputDecoration(
                      labelText: 'From',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, true),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: _endDate == null
                        ? TextEditingController(text: '')
                        : TextEditingController(
                        text: DateFormat('yyyy-MM-dd').format(_endDate!)),
                    decoration: InputDecoration(
                      labelText: 'To',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, false),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => _searchProducts(),
                child: Text('Search'),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.isEmpty
                    ? _productDetails.length
                    : _searchResults.length,
                itemBuilder: (context, index) {
                  final product = _searchResults.isEmpty
                      ? _productDetails[index]
                      : _searchResults[index];
                  return Card(
                    child: ListTile(
                      title: Text('${product['customer']} - ${product['product']}'),
                      subtitle: Text('Code: ${product['code']}, Color: ${product['color']}, Size: ${product['size']}, Quantity: ${product['quantity']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _showEditProductDialog(context, product),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteProduct(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddProductDialog(
        productDetails: _productDetails,
        addProductCallback: _addProduct,
      ),
    );
  }

  void _showEditProductDialog(BuildContext context, Map<String, String> product) {
    showDialog(
      context: context,
      builder: (context) => EditProductDialog(
        product: product,
        productDetails: _productDetails,
        editProductCallback: _editProduct,
      ),
    );
  }

  void _addProduct(Map<String, String> newProduct) {
    setState(() {
      _productDetails.add(newProduct);
    });
  }

  void _editProduct(Map<String, String> editedProduct) {
    setState(() {
      int index = _productDetails.indexWhere((product) => product['code'] == editedProduct['code']);
      if (index != -1) {
        _productDetails[index] = editedProduct;
      }
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      _productDetails.removeAt(index);
    });
  }

  void _searchProducts() {
    setState(() {
      _searchResults.clear();
      _productDetails.forEach((product) {
        bool matches = true;

        if (_searchProductController.text.isNotEmpty &&
            !product['product']!.toLowerCase().contains(
              _searchProductController.text.toLowerCase(),
            )) {
          matches = false;
        }

        if (_searchCodeController.text.isNotEmpty &&
            product['code'] != _searchCodeController.text) {
          matches = false;
        }

        if (_startDate != null &&
            DateTime.parse(product['date']!).isBefore(_startDate!)) {
          matches = false;
        }

        if (_endDate != null &&
            DateTime.parse(product['date']!).isAfter(_endDate!)) {
          matches = false;
        }

        if (matches) {
          _searchResults.add(product);
        }
      });
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }
}
