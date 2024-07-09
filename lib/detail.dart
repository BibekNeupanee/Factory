import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'add_product.dart';

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
      'date': '2023-05-20'
    },
    // Add more products as needed
  ];

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

  List<Map<String, String>> _searchResults = [];
  DateTime? _startDate;
  DateTime? _endDate;
  Random _random = Random();

  final TextEditingController _searchProductController =
      TextEditingController();
  final TextEditingController _searchCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final displayedProducts = _searchResults.isNotEmpty ||
            _startDate != null ||
            _endDate != null ||
            _searchProductController.text.isNotEmpty ||
            _searchCodeController.text.isNotEmpty
        ? _searchResults
        : _productDetails;

    return Scaffold(
      appBar: AppBar(
        title: Text('Details of ${widget.name}'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddProductDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search by',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchProductController,
                    decoration: InputDecoration(
                      labelText: 'Product',
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _searchCodeController.text.isEmpty
                        ? null
                        : _searchCodeController.text,
                    decoration: InputDecoration(
                      labelText: 'Code',
                    ),
                    items: _productDetails.map((product) {
                      return DropdownMenuItem<String>(
                        value: product['code'],
                        child: Text(product['code']!),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _searchCodeController.text = newValue!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a code';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    controller: TextEditingController(
                        text: _startDate == null
                            ? ''
                            : DateFormat('yyyy-MM-dd').format(_startDate!)),
                    decoration: InputDecoration(
                      labelText: 'From',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, true),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    controller: TextEditingController(
                        text: _endDate == null
                            ? ''
                            : DateFormat('yyyy-MM-dd').format(_endDate!)),
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
                onPressed: _search,
                child: Text('Search'),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: displayedProducts.isNotEmpty
                  ? ListView.builder(
                      itemCount: displayedProducts.length,
                      itemBuilder: (context, index) {
                        final product = displayedProducts[index];
                        return Card(
                          child: ListTile(
                            onTap: () => _showOptionsDialog(context, product),
                            title: Text(
                              product['product']!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Color: ${product['color']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  'Size: ${product['size']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  'Manufactured Date: ${product['date']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Text(product['quantity']!),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text('No products found.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddProductDialog(
          productDetails: _productDetails,
          addProductCallback: _addProduct,
        );
      },
    );
  }

  void _addProduct(Map<String, String> newProduct) {
    setState(() {
      _productDetails.add(newProduct);
    });
  }

  void _search() {
    setState(() {
      _searchResults.clear();
      _productDetails.forEach((product) {
        final productNameMatch = _searchProductController.text.isEmpty ||
            product['product']!
                .toLowerCase()
                .contains(_searchProductController.text.toLowerCase());
        final productCodeMatch = _searchCodeController.text.isEmpty ||
            product['code'] == _searchCodeController.text;
        final startDateMatch = _startDate == null ||
            product['date']!.compareTo(
                    _startDate!.toLocal().toString().split(' ')[0]) >=
                0;
        final endDateMatch = _endDate == null ||
            product['date']!
                    .compareTo(_endDate!.toLocal().toString().split(' ')[0]) <=
                0;

        if (productNameMatch &&
            productCodeMatch &&
            startDateMatch &&
            endDateMatch) {
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
    if (picked != null && picked != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _showOptionsDialog(BuildContext context, Map<String, String> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Options for ${product['product']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showEditProductDialog(context, product);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
                onTap: () {
                  Navigator.of(context).pop();
                  _confirmDelete(context, product);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditProductDialog(
      BuildContext context, Map<String, String> product) {
    final _editCustomerController =
        TextEditingController(text: product['customer']);
    final _editProductController =
        TextEditingController(text: product['product']);
    final _editCodeController = TextEditingController(text: product['code']);
    final _editColorController = TextEditingController(text: product['color']);
    final _editSizeController = TextEditingController(text: product['size']);
    final _editQuantityController =
        TextEditingController(text: product['quantity']);
    final GlobalKey<FormState> _editFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Product'),
          content: Form(
            key: _editFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _editCustomerController.text,
                  decoration: InputDecoration(
                    labelText: 'Customer',
                  ),
                  items: _productDetails.map((product) {
                    return DropdownMenuItem<String>(
                      value: product['customer'],
                      child: Text(product['customer']!),
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
                  items: _productDetails.map((product) {
                    return DropdownMenuItem<String>(
                      value: product['product'],
                      child: Text(product['product']!),
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
                  items: _productDetails.map((product) {
                    return DropdownMenuItem<String>(
                      value: product['code'],
                      child: Text(product['code']!),
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
                  items: _productDetails.map((product) {
                    return DropdownMenuItem<String>(
                      value: product['color'],
                      child: Text(product['color']!),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _editColorController.text = newValue!;
                    });
                  },
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
              child: Text('Save'),
              onPressed: () {
                if (_editFormKey.currentState!.validate()) {
                  setState(() {
                    product['customer'] = _editCustomerController.text;
                    product['product'] = _editProductController.text;
                    product['code'] = _editCodeController.text;
                    product['color'] = _editColorController.text;
                    product['size'] = _editSizeController.text;
                    product['quantity'] = _editQuantityController.text;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Map<String, String> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content:
              Text('Are you sure you want to delete ${product['product']}?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                setState(() {
                  _productDetails.remove(product);
                  _search();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
