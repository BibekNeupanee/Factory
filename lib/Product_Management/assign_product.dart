import 'package:flutter/material.dart';

class AssignProductPage extends StatefulWidget {
  final String name;
  final List<Map<String, String>> productDetails;

  AssignProductPage({required this.name, required this.productDetails});

  @override
  _AssignProductPageState createState() => _AssignProductPageState();
}

class _AssignProductPageState extends State<AssignProductPage> {
  final List<String> _staff = [
    'John Doe',
    'Jane Smith',
    'Alice Johnson',
    'Bob Brown'
  ];
  final List<String> _colors = ['Red', 'Green', 'Blue', 'Black', 'White'];
  final List<String> _sizes = [
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
  final List<String> _products = [
    'Tshirt',
    'Trouser',
    'Jeans',
    'Jacket',
    'Shoes'
  ];

  String? _selectedStaff;
  String? _selectedColor;
  String? _selectedSize;
  String? _selectedProduct;
  String? _quantity;

  final List<Map<String, String>> _assignedProducts = [];

  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Product To ${widget.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Staff'),
              items: _staff.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedStaff = newValue;
                });
              },
              value: _selectedStaff,
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Product'),
              items: _products.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedProduct = newValue;
                });
              },
              value: _selectedProduct,
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Color'),
              items: _colors.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedColor = newValue;
                });
              },
              value: _selectedColor,
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Size'),
              items: _sizes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedSize = newValue;
                });
              },
              value: _selectedSize,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Quantity'),
              controller: _quantityController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _quantity = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _assignProduct,
              child: Text('Assign'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _assignedProducts.length,
                itemBuilder: (context, index) {
                  final product = _assignedProducts[index];
                  return Card(
                    child: ListTile(
                      title: Text('Staff: ${product['staff']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Product: ${product['product']}'),
                          Text('Color: ${product['color']}'),
                          Text('Size: ${product['size']}'),
                          Text('Quantity: ${product['quantity']}'),
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
    );
  }

  void _assignProduct() {
    if (_selectedStaff != null &&
        _selectedColor != null &&
        _selectedSize != null &&
        _selectedProduct != null &&
        _quantity != null &&
        _quantity!.isNotEmpty) {
      setState(() {
        _assignedProducts.add({
          'staff': _selectedStaff!,
          'product': _selectedProduct!,
          'color': _selectedColor!,
          'size': _selectedSize!,
          'quantity': _quantity!,
        });
        _selectedStaff = null;
        _selectedProduct = null;
        _selectedColor = null;
        _selectedSize = null;
        _quantityController.clear();
      });
    } else {
      // Show a snackbar or alert dialog to notify the user to fill all fields
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields'),
        ),
      );
    }
  }
}
