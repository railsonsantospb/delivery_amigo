import 'package:flutter/material.dart';


class TableProducts extends StatefulWidget {
  var list_product;

  TableProducts({this.list_product});

  @override
  _TableProductsState createState() => _TableProductsState();
}

class _TableProductsState extends State<TableProducts> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Tutorials',
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter Table Example')),
        body: DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'Name',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'Age',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'Role',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
          rows: const <DataRow>[
            DataRow(
              cells: <DataCell>[
                DataCell(Text('Ravi')),
                DataCell(Text('19')),
                DataCell(Text('Student')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('Jane')),
                DataCell(Text('43')),
                DataCell(Text('Professor')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('William')),
                DataCell(Text('27')),
                DataCell(Text('Professor')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
