import 'package:flutter/material.dart';
import 'package:greek_news_app/global_constants/db_categories.dart';

class AddNew extends StatefulWidget {
  AddNew(this.db_data);
  // ignore: non_constant_identifier_names
  final db_data;
  @override
  _AddNewState createState() => _AddNewState();
}

class _AddNewState extends State<AddNew> {
  String dropdownValue;
  // ignore: non_constant_identifier_names
  List inner_db_categories = [];
  final _nameController = TextEditingController();
  final _linkController = TextEditingController();
  @override
  void initState() {
    super.initState();

    widget.db_data.forEach((v) {
      inner_db_categories.add(v['name'].toString());
    });
    dropdownValue = widget.db_data[0]['name'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      body: Container(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
              DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items:
                    inner_db_categories.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              Text('Select category'),
              Divider(),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name of the portal',
                ),
              ),
              Divider(),
              TextField(
                controller: _linkController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'link',
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                    onPressed: () {
                      if (_nameController.text != null &&
                          _linkController != null) {
                        try {
                          // ignore: non_constant_identifier_names
                          db_categories.get().then((db_categories_data) {
                            List j =
                                new List.of(db_categories_data['categories']);
                            //
                            dynamic uri =
                                Uri.parse(_linkController.text.trim());
                            print(
                                'THIS IS HOST ${uri.scheme}://${uri.authority}');
                            j.asMap().forEach((key, el) {
                              if (el['name'] == dropdownValue) {
                                j[key]['list_of_links'].add({
                                  'name': _nameController.text.trim(),
                                  'link': _linkController.text.trim(),
                                  'favicon':
                                      '${uri.scheme}://${uri.authority}/favicon.ico'
                                });
                              }
                            });
                            db_categories.updateData({'categories': j});
                          });
                        } catch (e) {} finally {
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: Text('add news')),
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Add news'),
      ),
    ));
  }
}
