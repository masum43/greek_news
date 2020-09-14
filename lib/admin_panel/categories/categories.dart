import 'package:flutter/material.dart';
import 'package:greek_news_app/global_constants/db_categories.dart';
import './add_category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Categories extends StatefulWidget {
  Categories({Key key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<TextEditingController> _controllers = new List();
  // ignore: non_constant_identifier_names
  List edit_category_field;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddCategory()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('News categories'),
      ),
      body: Container(
        child: StreamBuilder(
          stream: db_categories.snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List data = snapshot.data['categories'];
              // ignore: non_constant_identifier_names
              if (edit_category_field == null ||
                  edit_category_field.length < data.length) {
                edit_category_field = new List.filled(data.length, false);
              }

              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  _controllers.add(new TextEditingController());
                  return !edit_category_field[index]
                      ? Card(
                          child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 0.0),
                                child: Text(
                                  data[index]['name'],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        setState(() {
                                          edit_category_field[index] = true;
                                        });
                                      }),
                                  IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () async {
                                        try {
                                          await db_categories.updateData({
                                            'categories':
                                                FieldValue.arrayRemove(
                                                    [data[index]])
                                          });
                                        } catch (e) {
                                          print('THIS IS THE ERROR : $e');
                                        }
                                      })
                                ],
                              )
                            ],
                          ),
                        ))
                      : Row(
                          children: <Widget>[
                            Flexible(
                                child: Container(
                              width: 350.0,
                              padding: EdgeInsets.only(left: 12.0),
                              child: TextField(
                                controller: _controllers[index],
                              ),
                            )),
                            IconButton(
                              icon: Icon(Icons.check),
                              onPressed: () async {
                                try {
                                  List categories = new List.of(data);
                                  categories[index]['name'] =
                                      _controllers[index].text.trim();
                                  await db_categories
                                      .updateData({'categories': categories});
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //
                                  //
                                } catch (e) {
                                  print('THIS IS THE ERROR : $e');
                                } finally {
                                  setState(() {
                                    edit_category_field[index] = false;
                                  });
                                }
                              },
                            )
                          ],
                        );
                },
              );
            } else
              return Container();
          },
        ),
      ),
    );
  }
}
