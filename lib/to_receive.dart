import 'package:flutter/material.dart';

class ToReceivePage extends StatefulWidget {
  final List<Map<String, String>> productDetails;

  ToReceivePage({required this.productDetails});

  @override
  _ToReceivePageState createState() => _ToReceivePageState();
}

class _ToReceivePageState extends State<ToReceivePage> {
  List<Map<String, String>> productsToReceive = [];

  @override
  void initState() {
    super.initState();
    _filterProductsToReceive();
  }

  void _filterProductsToReceive() {
    productsToReceive = widget.productDetails.where((product) {
      int remaining =
          int.parse(product['quantity']!) - int.parse(product['received']!);
      return remaining > 0;
    }).toList();
  }

  void _showEditReceivedDialog(
      BuildContext context, Map<String, String> product) {
    TextEditingController _receivedController =
        TextEditingController(text: product['received']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Received Quantity'),
          content: TextField(
            controller: _receivedController,
            decoration: InputDecoration(labelText: 'Received Quantity'),
            keyboardType: TextInputType.number,
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
                setState(() {
                  product['received'] = _receivedController.text;
                  _filterProductsToReceive(); // Refresh the list to reflect changes
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Receive Products'),
      ),
      body: ListView.builder(
        itemCount: productsToReceive.length,
        itemBuilder: (context, index) {
          final product = productsToReceive[index];
          final int remaining =
              int.parse(product['quantity']!) - int.parse(product['received']!);
          return Card(
            child: ListTile(
              title: Text('${product['product']} - Remaining: $remaining'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Customer: ${product['customer']}'),
                  Text('Size: ${product['size']}'),
                  Text('Color: ${product['color']}'),
                ],
              ),
              onTap: () => _showEditReceivedDialog(context, product),
            ),
          );
        },
      ),
    );
  }
}