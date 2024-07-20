import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'edit_order.dart'; // Import the EditOrderDialog

class ViewOrderPage extends StatefulWidget {
  @override
  _ViewOrderPageState createState() => _ViewOrderPageState();
}

class _ViewOrderPageState extends State<ViewOrderPage> {
  final List<Map<String, dynamic>> orderDetails = [
    {
      'customer': 'John Doe',
      'orderDate': '2023-07-01',
      'deliveryDate': '2023-07-10',
      'products': ['Product 1', 'Product 2'],
      'totalAmount': 55.0,
      'colors': ['Red', 'Blue'],
      'sizes': ['M', 'L'],
      'quantities': {
        'Red': {'M': 10, 'L': 15},
        'Blue': {'M': 20, 'L': 10}
      }
    },
    {
      'customer': 'Jane Smith',
      'orderDate': '2023-07-02',
      'deliveryDate': '2023-07-12',
      'products': ['Product 3'],
      'totalAmount': 30.0,
      'colors': ['Green'],
      'sizes': ['S'],
      'quantities': {
        'Green': {'S': 30}
      }
    },
    {
      'customer': 'Alice Johnson',
      'orderDate': '2023-07-03',
      'deliveryDate': '2023-07-13',
      'products': ['Product 4', 'Product 5'],
      'totalAmount': 75.0,
      'colors': ['Yellow', 'Black'],
      'sizes': ['XL', 'XXL'],
      'quantities': {
        'Yellow': {'XL': 25, 'XXL': 10},
        'Black': {'XL': 20, 'XXL': 20}
      }
    },
  ];

  String? selectedCustomer;
  DateTime? selectedDate;
  String? selectedProduct;
  List<String> customers = [];
  List<String> products = [];
  List<Map<String, dynamic>> filteredOrders = [];

  @override
  void initState() {
    super.initState();
    customers = orderDetails
        .map((order) => order['customer'] as String)
        .toSet()
        .toList();
    products = orderDetails
        .expand((order) => order['products'] as List<String>)
        .toSet()
        .toList();
    filteredOrders = List.from(orderDetails);
  }

  void filterOrders() {
    setState(() {
      filteredOrders = orderDetails.where((order) {
        final matchesCustomer =
            selectedCustomer == null || order['customer'] == selectedCustomer;
        final matchesDate = selectedDate == null ||
            order['orderDate'] ==
                DateFormat('yyyy-MM-dd').format(selectedDate!);
        final matchesProduct = selectedProduct == null ||
            (order['products'] as List).contains(selectedProduct);
        return matchesCustomer && matchesDate && matchesProduct;
      }).toList();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        filterOrders();
      });
    }
  }

  void clearFilters() {
    setState(() {
      selectedCustomer = null;
      selectedDate = null;
      selectedProduct = null;
      filteredOrders = List.from(orderDetails);
    });
  }

  void _editOrder(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return EditOrderDialog(
          order: filteredOrders[index],
          onSave: (updatedOrder) {
            setState(() {
              orderDetails[index] = updatedOrder;
              filterOrders();
            });
          },
        );
      },
    );
  }

  void _deleteOrder(int index) {
    setState(() {
      orderDetails.removeAt(index);
      filterOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Orders'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Search by Customer Name',
                      suffixIcon: selectedCustomer != null
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  selectedCustomer = null;
                                  filterOrders();
                                });
                              },
                            )
                          : null,
                    ),
                    items: customers.map((customer) {
                      return DropdownMenuItem<String>(
                        value: customer,
                        child: Text(customer),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedCustomer = newValue;
                        filterOrders();
                      });
                    },
                    value: selectedCustomer,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Search by Order Date',
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (selectedDate != null)
                            IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  selectedDate = null;
                                  filterOrders();
                                });
                              },
                            ),
                          IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context),
                          ),
                        ],
                      ),
                    ),
                    controller: TextEditingController(
                      text: selectedDate == null
                          ? ''
                          : DateFormat('yyyy-MM-dd').format(selectedDate!),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Search by Product Name',
                      suffixIcon: selectedProduct != null
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  selectedProduct = null;
                                  filterOrders();
                                });
                              },
                            )
                          : null,
                    ),
                    items: products.map((product) {
                      return DropdownMenuItem<String>(
                        value: product,
                        child: Text(product),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedProduct = newValue;
                        filterOrders();
                      });
                    },
                    value: selectedProduct,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
                  return Card(
                    child: ListTile(
                      title: Text('Customer: ${order['customer']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order Date: ${order['orderDate']}'),
                          Text('Delivery Date: ${order['deliveryDate']}'),
                          Text('Products: ${order['products'].join(', ')}'),
                          Text('Total Quantity: ${order['totalAmount']}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editOrder(context, index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteOrder(index),
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
    );
  }
}
