import 'package:factory_flutter/Order_Management/View_Order/view_order.dart';
import 'package:flutter/material.dart';
import 'detail.dart';
import 'nav_bar.dart';
import 'Order_Management/add_order.dart'; // Import the new add_order.dart file

class DashboardPage extends StatefulWidget {
  final String title;

  DashboardPage({required this.title});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<String> names = [
    'Alice',
    'Bob',
    'Charlie',
    'David',
    'Eve',
    'Frank',
    'Grace',
    'Hank',
    'Ivy',
    'Jack'
  ];
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: NavBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (widget.title == 'Dashboard') {
      return Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Search',
              suffixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                query = value;
              });
            },
          ),
          Expanded(
            child: ListView(
              children: names
                  .where((name) =>
                      name.toLowerCase().startsWith(query.toLowerCase()))
                  .map((name) => ListTile(
                        title: Text(name),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(name: name),
                            ),
                          );
                        },
                      ))
                  .toList(),
            ),
          ),
        ],
      );
    }
    else if (widget.title == 'Add Order') {
      return AddOrderPage(); // Return the AddOrderPage widget
    }
    else if (widget.title == 'View Order'){
      return ViewOrderPage();
    }
    else {
      return Center(
        child: Text('You are in ${widget.title}'),
      );
    }
  }
}
