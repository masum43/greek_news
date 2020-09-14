import 'package:flutter/material.dart';
import 'categories/categories.dart';
import 'news/news.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminPanelDashboard extends StatefulWidget {
  AdminPanelDashboard({Key key}) : super(key: key);

  @override
  _AdminPanelDashboardState createState() => _AdminPanelDashboardState();
}

class _AdminPanelDashboardState extends State<AdminPanelDashboard> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  _firebaseAuth.signOut();
                })
          ],
          title: Text('Admin panel'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 220.0,
                height: 220.0,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Center(
                  child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Categories()));
                      },
                      child: Text(
                        'Categories',
                        style: TextStyle(fontSize: 28.0, color: Colors.white),
                      )),
                ),
              ),
              Container(
                width: 220.0,
                height: 220.0,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Center(
                  child: FlatButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AddNews()));
                      },
                      child: Text('News',
                          style:
                              TextStyle(fontSize: 28.0, color: Colors.white))),
                ),
              ),
            ],
          ),
        ));
  }
}
