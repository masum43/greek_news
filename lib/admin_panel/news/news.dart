import 'package:flutter/material.dart';
import 'add_news.dart';
import '../../global_constants/db_categories.dart';

class AddNews extends StatefulWidget {
  AddNews({Key key}) : super(key: key);

  @override
  _AddNewsState createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {
  List dataB;

  // ignore: non_constant_identifier_names
  List _controllers_of_names = List();

  // ignore: non_constant_identifier_names
  List _controllers_of_links = List();
  // ignore: non_constant_identifier_names
  List edit_news_field = List();
  void initState() {
    super.initState();
    db_categories.get().then((data) {
      dataB = new List.from(data['categories']);
    });
    print(dataB);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All News'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddNew(dataB)));
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: db_categories.snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          List categoriesData = snapshot.data['categories'];
          return ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: categoriesData.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  Card(
                    child: Center(
                        child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        categoriesData[index]['name'],
                        style: TextStyle(fontSize: 24.0),
                      ),
                    )),
                  ),
                  SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(maxHeight: 150000.0, minHeight: 150.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount:
                            categoriesData[index]['list_of_links'].length,
                        itemBuilder: (BuildContext ctx, int i) {
                          if (edit_news_field.length < 1 ||
                              edit_news_field.length <
                                  categoriesData[index]['list_of_links']
                                      .length) {
                            edit_news_field.addAll([
                              new List.filled(
                                  categoriesData[index]['list_of_links'].length,
                                  false,
                                  growable: true)
                            ]);
                          }
                          if (_controllers_of_names.length < 1 ||
                              edit_news_field.length <
                                  categoriesData[index]['list_of_links']
                                      .length) {
                            _controllers_of_names.addAll([
                              new List.filled(
                                  categoriesData[index]['list_of_links'].length,
                                  new TextEditingController(),
                                  growable: true)
                            ]);
                          }
                          if (_controllers_of_links.length < 1 ||
                              edit_news_field.length <
                                  categoriesData[index]['list_of_links']
                                      .length) {
                            _controllers_of_links.addAll([
                              new List.filled(
                                  categoriesData[index]['list_of_links'].length,
                                  new TextEditingController(),
                                  growable: true)
                            ]);
                          }
                          print(_controllers_of_links.length);
                          return Column(
                            children: <Widget>[
                              Card(
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(children: <Widget>[
                                        !edit_news_field[index][i]
                                            ? Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 16.0,
                                                      bottom: 16.0,
                                                      left: 16.0),
                                                  child: Text(
                                                      categoriesData[index]
                                                              ['list_of_links']
                                                          [i]['name']),
                                                ),
                                              )
                                            : Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.0),
                                                child: TextField(
                                                  controller:
                                                      _controllers_of_names[
                                                          index][i],
                                                ),
                                              ),
                                        Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: Text('website name'),
                                            )),
                                        !edit_news_field[index][i]
                                            ? Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 16.0,
                                                      bottom: 16.0,
                                                      left: 16.0),
                                                  child: Text(
                                                      categoriesData[index]
                                                              ['list_of_links']
                                                          [i]['link']),
                                                ),
                                              )
                                            : Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.0),
                                                child: TextField(
                                                  controller:
                                                      _controllers_of_links[
                                                          index][i],
                                                ),
                                              ),
                                        Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: Text('website link'),
                                            )),
                                      ]))),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  !edit_news_field[index][i]
                                      ? IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            setState(() {
                                              edit_news_field[index][i] = true;
                                              print(
                                                  'full list is: $edit_news_field');
                                              print(
                                                  'controllers length: ${_controllers_of_names}');
                                            });
                                          })
                                      : IconButton(
                                          icon: Icon(Icons.check),
                                          onPressed: () async {
                                            setState(() {
                                              edit_news_field[index][i] = false;
                                            });

                                            await db_categories.get()
                                                // ignore: non_constant_identifier_names
                                                .then(
                                                    // ignore: non_constant_identifier_names
                                                    (db_categories_data) async {
                                              List j = new List.of(
                                                  db_categories_data[
                                                      'categories']);

                                              j[index]['list_of_links'][i]
                                                      ['name'] =
                                                  _controllers_of_names[index]
                                                          [i]
                                                      .text
                                                      .trim();
                                              j[index]['list_of_links'][i]
                                                      ['link'] =
                                                  _controllers_of_links[index]
                                                          [i]
                                                      .text
                                                      .trim();
                                              await db_categories.updateData(
                                                  {'categories': j});
                                            });
                                          }),
                                  IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () async {
                                        await db_categories.get()
                                            // ignore: non_constant_identifier_names
                                            .then((db_categories_data) async {
                                          List j = new List.of(
                                              db_categories_data['categories']);
                                          j[index]['list_of_links']
                                              .removeRange(i, i + 1);
                                          await db_categories
                                              .updateData({'categories': j});
                                        });
                                      }),
                                ],
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Divider()
                ],
              );
            },
          );
        },
      ),
    );
  }
}
