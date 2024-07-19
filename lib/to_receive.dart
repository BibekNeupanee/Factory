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
      int quantity = int.tryParse(product['quantity'] ?? '0') ?? 0;
      int received = int.tryParse(product['received'] ?? '0') ?? 0;
      int alter = int.tryParse(product['alter'] ?? '0') ?? 0;
      int remaining = quantity - received - alter;

      return remaining > 0;
    }).toList();
  }

  void _showEditReceivedDialog(
      BuildContext context, Map<String, String> product) {
    TextEditingController _receivedController =
        TextEditingController(text: product['received']);
    TextEditingController _receivingController =
        TextEditingController(text: '0');
    TextEditingController _alterController =
        TextEditingController(text: product['alter']);
    int quantity = int.tryParse(product['quantity'] ?? '0') ?? 0;
    int received = int.tryParse(product['received'] ?? '0') ?? 0;
    int alter = int.tryParse(product['alter'] ?? '0') ?? 0;
    int remaining = quantity - received - alter;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Received Quantity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Remaining Quantity: $remaining'),
              TextField(
                controller: _receivingController,
                decoration: InputDecoration(labelText: 'Receiving'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _alterController,
                decoration: InputDecoration(labelText: 'Alter'),
                keyboardType: TextInputType.number,
              ),
            ],
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
                int receivingValue =
                    int.tryParse(_receivingController.text) ?? 0;
                int alterValue = int.tryParse(_alterController.text) ?? 0;

                if ((quantity - received - receivingValue - alterValue) < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Receiving quantity cannot be greater than total quantity'),
                    ),
                  );
                } else {
                  setState(() {
                    product['received'] =
                        (received + receivingValue).toString();
                    product['alter'] = alterValue.toString();
                    _filterProductsToReceive(); // Refresh the list to reflect changes
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
          int quantity = int.tryParse(product['quantity'] ?? '0') ?? 0;
          int received = int.tryParse(product['received'] ?? '0') ?? 0;
          int alter = int.tryParse(product['alter'] ?? '0') ?? 0;
          int remaining = quantity - received - alter;
          final bool isCompleted = remaining == 0;

          return Card(
            child: ListTile(
              title: Text('${product['product']} - Remaining: $remaining'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Customer: ${product['customer']}'),
                  Text('Size: ${product['size']}'),
                  Text('Color: ${product['color']}'),
                  Text('Alter: ${product['alter']}'),
                  Text(
                      'Status: ${isCompleted ? 'Completed' : 'Not Completed'}'),
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
