import 'dart:async';

import 'package:flutter/material.dart';
import 'package:native_flutter_admob/native_flutter_admob.dart';
import './admin_panel/sign_in.dart';
import './global_constants/db_categories.dart';
import './news.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './favorites.dart';
import 'package:admob_flutter/admob_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('favoritesBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Greek news app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.vollkornTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List data;

  void initState() {
    // TODO: implement initState
    super.initState();
    Admob.initialize('ca-app-pub-4788816498403375~2708230334');
  }

  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  DrawerHeader(
                    child: Container(
                      padding: EdgeInsets.only(top: 40.0),
                      child: Center(
                          child: Column(
                        children: <Widget>[
                          Text(
                            'All greek news',
                            style: TextStyle(fontSize: 24.0),
                          ),
                          Text(
                            'version 0.0.2',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ],
                      )),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Favorites()),
                      );
                    },
                    child: ListTile(
                        leading: Icon(Icons.favorite_border),
                        title: Text(
                          'ΕΠΙΛΟΓΕΣ',
                          style: TextStyle(fontSize: 20.0),
                        )),
                  ),
                ],
              ),
            ),
            Container(
                child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                        child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text('Contacts'),
                          subtitle: Text('email: thomopoulos79@gmail.com'),
                        ),
                        Divider(),
                        ListTile(
                            title: Center(
                                child: FlatButton(
                          onPressed: () {
                            _scaffoldKey.currentState.openEndDrawer();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignIn()),
                            );
                          },
                          child: Text('Sign in as admin'),
                        )))
                      ],
                    ))))
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          'All Greek News',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        backgroundColor: Hexcolor('#465BD2'),
      ),
      body: Container(
        child: StreamBuilder(
          stream: db_categories.snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) data = snapshot.data['categories'];
            if (snapshot.hasData && data != null)
              return ListView.separated(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    News(data[index]['name'])));
                      },
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Card(
                          color: Hexcolor('#78B9F2'),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                data[index]['name'],
                                style: TextStyle(
                                  fontSize: 22.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ));
                },
                separatorBuilder: (context, position) {
                  if (position == 5) {
                    // Display `AdmobBanner` every 5 'separators'.
                    return AdmobBanner(
                        adUnitId: 'ca-app-pub-4788816498403375/2598519318',
                        adSize: AdmobBannerSize.MEDIUM_RECTANGLE);
                  }
                  return Container();
                },
              );
            else
              return Container();
          },
        ),
      ),
    );
  }
}
