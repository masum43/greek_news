import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import './watch_news.dart';
import 'package:hexcolor/hexcolor.dart';

class Favorites extends StatefulWidget {
  Favorites({Key key}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  Box box = Hive.box('favoritesBox');
  dynamic categories;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Hexcolor('#465BD2'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Favorites',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: ListView.builder(
            itemCount: box.length,
            itemBuilder: (BuildContext context, int index) {
              Uri uri = Uri.parse(box.keyAt(index));
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              WatchNews(box.getAt(index), box.keyAt(index))),
                    );
                  },
                  child: new Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        minRadius: 25,
                        maxRadius: 40,
                        backgroundColor: Colors.transparent,
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/image-placeholder.png',
                          width: 40,
                          height: 40,
                          image:
                              'http://www.google.com/s2/favicons?sz=64&domain=${box.keyAt(index)}',
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        uri.host.replaceAll('www.', ''),
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ),
                  ),
                ),
              );
            }));
  }
}
