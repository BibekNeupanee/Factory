import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart'; // For input formatters

class EditOrderDialog extends StatefulWidget {
  final Map<String, dynamic> order;
  final Function(Map<String, dynamic>) onSave;

  EditOrderDialog({required this.order, required this.onSave});

  @override
  _EditOrderDialogState createState() => _EditOrderDialogState();
}

class _EditOrderDialogState extends State<EditOrderDialog> {
  late TextEditingController _customerController;
  late TextEditingController _orderDateController;
  late TextEditingController _deliveryDateController;
  late TextEditingController _productController;
  late List<String> _colors;
  late List<String> _sizes;
  late Map<String, Map<String, TextEditingController>> _quantities;
  int _totalQuantity = 0;

  @override
  void initState() {
    super.initState();
    _customerController = TextEditingController(text: widget.order['customer']);
    _orderDateController =
        TextEditingController(text: widget.order['orderDate']);
    _deliveryDateController =
        TextEditingController(text: widget.order['deliveryDate']);
    _productController =
        TextEditingController(text: widget.order['products'].join(', '));
    _colors = List<String>.from(widget.order['colors']);
    _sizes = List<String>.from(widget.order['sizes']);
    _quantities = {};

    for (var color in _colors) {
      _quantities[color] = {};
      for (var size in _sizes) {
        _quantities[color]![size] = TextEditingController(
          text: widget.order['quantities'][color]?[size]?.toString() ?? '',
        );
        _quantities[color]![size]!.addListener(_updateTotalQuantity);
      }
    }
    _updateTotalQuantity();
  }

  void _updateTotalQuantity() {
    int total = 0;
    for (var color in _quantities.values) {
      for (var controller in color.values) {
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

  void _addNewColor() {
    setState(() {
      String newColor = '';
      _colors.add(newColor);
      _quantities[newColor] = {
        for (var size in _sizes) size: TextEditingController()
      };
      for (var size in _sizes) {
        _quantities[newColor]![size]!.addListener(_updateTotalQuantity);
      }
    });
  }

  void _addNewSize() {
    setState(() {
      String newSize = '';
      _sizes.add(newSize);
      for (var quantity in _quantities.values) {
        quantity[newSize] = TextEditingController();
        quantity[newSize]!.addListener(_updateTotalQuantity);
      }
    });
  }

  void _removeColor(int index) {
    setState(() {
      String colorToRemove = _colors[index];
      _quantities.remove(colorToRemove);
      _colors.removeAt(index);
      _updateTotalQuantity();
    });
  }

  void _removeSize(int index) {
    String sizeToRemove = _sizes[index];
    setState(() {
      _sizes.removeAt(index);
      for (var quantity in _quantities.values) {
        quantity.remove(sizeToRemove);
      }
      _updateTotalQuantity();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Order'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _customerController,
              decoration: InputDecoration(labelText: 'Customer Name'),
            ),
            TextFormField(
              controller: _productController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextFormField(
              controller: _orderDateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Order Date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, _orderDateController),
                ),
              ),
            ),
            TextFormField(
              controller: _deliveryDateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Delivery Date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () =>
                      _selectDate(context, _deliveryDateController),
                ),
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: _sizes.length * 120.0 + 100,
                child: Table(
                  defaultColumnWidth: FixedColumnWidth(100.0),
                  border: TableBorder.all(color: Colors.black),
                  children: [
                    TableRow(
                      children: [
                        TableCell(child: Center(child: Text('Color'))),
                        ..._sizes.asMap().entries.map((entry) {
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
                                    items: _sizes.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        _sizes[index] = newValue!;
                                        for (var quantity
                                            in _quantities.values) {
                                          quantity[newValue] =
                                              TextEditingController();
                                          quantity[newValue]!.addListener(
                                              _updateTotalQuantity);
                                        }
                                      });
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
                                    onChanged: (newValue) {
                                      setState(() {
                                        _colors[index] = newValue;
                                        _quantities[newValue] =
                                            _quantities.remove(color) ?? {};
                                      });
                                    },
                                    decoration:
                                        InputDecoration(labelText: 'Color'),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => _removeColor(index),
                                ),
                              ],
                            ),
                          ),
                          ..._sizes.map((size) {
                            if (!_quantities[color]!.containsKey(size)) {
                              _quantities[color]![size] =
                                  TextEditingController();
                              _quantities[color]![size]!
                                  .addListener(_updateTotalQuantity);
                            }
                            return TableCell(
                              child: TextFormField(
                                controller: _quantities[color]![size],
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: false),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration:
                                    InputDecoration(labelText: 'Quantity'),
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
              'Total Quantity: $_totalQuantity',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Map<String, dynamic> updatedOrder = {
              'customer': _customerController.text,
              'orderDate': _orderDateController.text,
              'deliveryDate': _deliveryDateController.text,
              'products': _productController.text.split(', '),
              'totalAmount': _totalQuantity,
              'colors': _colors,
              'sizes': _sizes,
              'quantities': {
                for (var color in _colors)
                  color: {
                    for (var size in _sizes)
                      size: int.tryParse(_quantities[color]![size]!.text) ?? 0
                  }
              }
            };
            widget.onSave(updatedOrder);
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
