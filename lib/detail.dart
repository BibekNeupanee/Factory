import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_product.dart';
import 'edit_product.dart';
import 'to_receive.dart';
import 'assign_product.dart';
import 'ledger.dart';

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
      'date': '2023-07-01',
      'received': '30',
    },
    {
      'customer': 'Jane Smith',
      'product': 'Trouser',
      'code': 'Code2',
      'color': 'Black',
      'size': 'L',
      'quantity': '30',
      'date': '2023-06-15',
      'received': '20',
    },
    {
      'customer': 'Alice Johnson',
      'product': 'Jeans',
      'code': 'Code3',
      'color': 'Blue',
      'size': 'XL',
      'quantity': '40',
      'date': '2023-06-20',
      'received': '35',
    },
  ];

  TextEditingController _searchProductController = TextEditingController();
  TextEditingController _searchCodeController = TextEditingController();
  List<Map<String, String>> _searchResults = [];
  DateTime? _startDate;
  DateTime? _endDate;

  List<String> _products = [];
  List<String> _codes = [];

  @override
  void initState() {
    super.initState();
    _populateDropdownData();
  }

  void _populateDropdownData() {
    _products = ['None'] +
        _productDetails.map((product) => product['product']!).toSet().toList();
    _codes = ['None'] +
        _productDetails.map((product) => product['code']!).toSet().toList();
  }

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
                Text(
                  'Search Products',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LedgerPage()
                              // LedgerPage(name: widget.name)
                      ),
                    );
                  },
                  child: Text('Ledger of ${widget.name}'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Search Product'),
                    items: _products.map((product) {
                      return DropdownMenuItem<String>(
                        value: product,
                        child: Text(product),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      _searchProductController.text = newValue!;
                    },
                    value: 'None',
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Search Code'),
                    items: _codes.map((code) {
                      return DropdownMenuItem<String>(
                        value: code,
                        child: Text(code),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      _searchCodeController.text = newValue!;
                    },
                    value: 'None',
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
            SizedBox(height: 40),
            Container(
              child: ElevatedButton(
                onPressed: () => _searchProducts(),
                child: Text('Search'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(50, 40), // Adjust height here
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Products',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ToReceivePage(productDetails: _productDetails)),
                    );
                  },
                  child: Text('To Receive'),
                ),
              ],
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
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${product['product']}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text('Size: ${product['size']}'),
                              SizedBox(width: 16),
                              Text('Color: ${product['color']}'),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text('Customer: ${product['customer']}'),
                          SizedBox(height: 8),
                          Text('Quantity: ${product['quantity']}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () =>
                                _showEditProductDialog(context, product),
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
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Add Product'),
                  onTap: () {
                    Navigator.pop(context); // Close the bottom sheet
                    _showAddProductDialog(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.assignment),
                  title: Text('Assign Product'),
                  onTap: () {
                    Navigator.pop(context); // Close the bottom sheet
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AssignProductPage(
                          name: widget.name,
                          productDetails: _productDetails,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
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

  void _showEditProductDialog(
      BuildContext context, Map<String, String> product) {
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
      int index = _productDetails
          .indexWhere((product) => product['code'] == editedProduct['code']);
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
            _searchProductController.text != 'None' &&
            product['product'] != _searchProductController.text) {
          matches = false;
        }

        if (_searchCodeController.text.isNotEmpty &&
            _searchCodeController.text != 'None' &&
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

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }
}
