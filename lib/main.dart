import 'package:flutter/material.dart';
import 'package:sqlite_exp/database_helper.dart';
import 'package:sqlite_exp/payment.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  TextEditingController amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Database and Payment'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () async {
                int i = await DataBaseHelper.instance
                    .insert({DataBaseHelper.columnName: 'Naman'});
                print(i);
              },
              color: Colors.blueAccent,
              child: Text('Insert'),
            ),
            RaisedButton(
              onPressed: () async {
                int updatedRows = await DataBaseHelper.instance.update({
                  DataBaseHelper.columnId: 1,
                  DataBaseHelper.columnName: 'Naman'
                });
                print(updatedRows);
              },
              color: Colors.purple,
              child: Text('Update'),
            ),
            RaisedButton(
              onPressed: () async {
                List<Map<String, dynamic>> query =
                    await DataBaseHelper.instance.queryAll();
                print(query);
              },
              color: Colors.green,
              child: Text('Query'),
            ),
            RaisedButton(
              onPressed: () async {
                int deletedRows = await DataBaseHelper.instance.delete(1);
                print(deletedRows);
              },
              color: Colors.white24,
              child: Text('Delete'),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                controller: amountController,
                decoration: InputDecoration(hintText: "Enter Amount To pay"),
                focusNode: FocusNode(canRequestFocus: false),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              color: Colors.black,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Payment(
                        amount: amountController.value.text,
                      );
                    },
                  ),
                );
              },
              child: Text(
                'Pay Now',
                style: TextStyle(color: Colors.blueAccent),
              ),
            )
          ],
        ),
      ),
    );
  }
}
