import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatters
import 'package:intl/intl.dart'; // For date formatting

class AddOrderPage extends StatefulWidget {
  @override
  _AddOrderPageState createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  List<String> _availableSizes = [
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
  List<String> _selectedSizes = [];
  List<String> _colors = [];
  List<Map<String, TextEditingController>> _quantities = [];
  List<Order> _orders = [];

  TextEditingController _customerController = TextEditingController();
  TextEditingController _productController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _orderDateController = TextEditingController();
  TextEditingController _deliveryDateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  int _totalQuantity = 0;

  void _addNewColor() {
    setState(() {
      _colors.add('');
      _quantities.add({
        for (var size in _selectedSizes)
          size: TextEditingController()
            ..addListener(() => _updateTotalQuantity())
      });
    });
  }

  void _addNewSize() {
    setState(() {
      _selectedSizes.add('');
      for (var quantity in _quantities) {
        quantity[_selectedSizes.last] = TextEditingController()
          ..addListener(() => _updateTotalQuantity());
      }
    });
  }

  void _removeColor(int index) {
    setState(() {
      _colors.removeAt(index);
      _quantities.removeAt(index);
      _updateTotalQuantity();
    });
  }

  void _removeSize(int index) {
    String sizeToRemove = _selectedSizes[index];
    setState(() {
      _selectedSizes.removeAt(index);
      for (var quantity in _quantities) {
        quantity.remove(sizeToRemove);
      }
      _updateTotalQuantity();
    });
  }

  void _addOrder() {
    if (_formKey.currentState!.validate()) {
      List<Entry> entries = [];
      for (int i = 0; i < _colors.length; i++) {
        for (String size in _selectedSizes) {
          entries.add(Entry(
            color: _colors[i],
            size: size,
            quantity: _quantities[i][size]?.text ?? '',
          ));
        }
      }

      setState(() {
        _orders.add(Order(
          customer: _customerController.text,
          product: _productController.text,
          code: _codeController.text,
          orderDate: _orderDateController.text,
          deliveryDate: _deliveryDateController.text,
          entries: entries,
        ));

        // Clear fields after adding to list
        _customerController.clear();
        _productController.clear();
        _codeController.clear();
        _orderDateController.clear();
        _deliveryDateController.clear();
        _colors.clear();
        _selectedSizes.clear();
        _quantities.clear();
        _totalQuantity = 0;
      });
    }
  }

  void _updateTotalQuantity() {
    int total = 0;
    for (var quantity in _quantities) {
      for (var controller in quantity.values) {
        total += int.tryParse(controller.text) ?? 0;
      }
    }
    setState(() {
      _totalQuantity = total;
    });
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _customerController,
              decoration: InputDecoration(labelText: 'Customer Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter customer name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _productController,
              decoration: InputDecoration(labelText: 'Product Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter product name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _codeController,
              decoration: InputDecoration(labelText: 'Code'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter code';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _orderDateController,
              decoration: InputDecoration(
                labelText: 'Order Date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, _orderDateController),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select order date';
                }
                return null;
              },
              readOnly: true,
            ),
            TextFormField(
              controller: _deliveryDateController,
              decoration: InputDecoration(
                labelText: 'Delivery Date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () =>
                      _selectDate(context, _deliveryDateController),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select delivery date';
                }
                return null;
              },
              readOnly: true,
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: _selectedSizes.length * 120.0 + 100,
                // Adjust the width based on the number of sizes
                child: Table(
                  defaultColumnWidth: FixedColumnWidth(100.0),
                  border: TableBorder.all(color: Colors.black),
                  children: [
                    TableRow(
                      children: [
                        TableCell(child: Center(child: Text('Color'))),
                        ..._selectedSizes.asMap().entries.map((entry) {
                          int index = entry.key;
                          String size = entry.value;
                          return TableCell(
                            child: Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: size.isEmpty ? null : size,
                                    decoration:
                                        InputDecoration(labelText: 'Size'),
                                    items: _availableSizes.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedSizes[index] = newValue!;
                                        // Update quantities map with new size
                                        for (var quantity in _quantities) {
                                          quantity[newValue] =
                                              TextEditingController()
                                                ..addListener(() =>
                                                    _updateTotalQuantity());
                                        }
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select size';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => _removeSize(index),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                    ..._colors.asMap().entries.map((entry) {
                      int index = entry.key;
                      String color = entry.value;
                      return TableRow(
                        children: [
                          TableCell(
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller:
                                        TextEditingController(text: color),
                                    onChanged: (newValue) => setState(
                                        () => _colors[index] = newValue),
                                    decoration:
                                        InputDecoration(labelText: 'Color'),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter color';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => _removeColor(index),
                                ),
                              ],
                            ),
                          ),
                          ..._selectedSizes.map((size) {
                            if (!_quantities[index].containsKey(size)) {
                              _quantities[index][size] = TextEditingController()
                                ..addListener(() => _updateTotalQuantity());
                            }
                            return TableCell(
                              child: TextFormField(
                                controller: _quantities[index][size],
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: false),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration:
                                    InputDecoration(labelText: 'Quantity'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter quantity';
                                  }
                                  return null;
                                },
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _addNewColor,
                  child: Text('Add Color'),
                ),
                ElevatedButton(
                  onPressed: _addNewSize,
                  child: Text('Add Size'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Total: $_totalQuantity',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addOrder,
              child: Text('Add Order'),
            ),
            SizedBox(height: 20),
            ..._orders
                .map((order) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Customer: ${order.customer}"),
                        Text("Product: ${order.product}"),
                        Text("Code: ${order.code}"),
                        Text("Order Date: ${order.orderDate}"),
                        Text("Delivery Date: ${order.deliveryDate}"),
                        ...order.entries.map((entry) => Text(
                            "Color: ${entry.color}, Size: ${entry.size}, Quantity: ${entry.quantity}")),
                        SizedBox(height: 10),
                      ],
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}

class Entry {
  final String color;
  final String size;
  final String quantity;

  Entry({required this.color, required this.size, required this.quantity});
}

class Order {
  final String customer;
  final String product;
  final String code;
  final String orderDate;
  final String deliveryDate;
  final List<Entry> entries;

  Order(
      {required this.customer,
      required this.product,
      required this.code,
      required this.orderDate,
      required this.deliveryDate,
      required this.entries});
}
