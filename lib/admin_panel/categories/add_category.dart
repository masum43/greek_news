import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../global_constants/db_categories.dart';

class AddCategory extends StatefulWidget {
  AddCategory({Key key}) : super(key: key);

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final _textController = TextEditingController();
  // ignore: non_constant_identifier_names
  dynamic news_data;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add category'),
      ),
      body: Container(
        child: Center(
            child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20.0),
          children: <Widget>[
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Category name',
              ),
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: FlatButton(
                      onPressed: () async {
                        try {
                          // ignore: non_constant_identifier_names
                          await db_categories.updateData({
                            'categories': FieldValue.arrayUnion([
                              {
                                'name': _textController.text.trim(),
                                'list_of_links': []
                              }
                            ])
                          }).then((value) => {Navigator.pop(context)});
                        } catch (e) {
                          print('THIS IS THE ERROR : $e');
                        } finally {}
                      },
                      child: Text('add category')),
                ))
          ],
        )),
      ),
    );
  }
}
