import 'package:flutter/material.dart';
import './global_constants/db_categories.dart';
import './watch_news.dart';
import 'package:hexcolor/hexcolor.dart';

class News extends StatefulWidget {
  News(this.catergoty);
  final catergoty;
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  List data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.catergoty,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Hexcolor('#465BD2'),
      ),
      body: StreamBuilder(
        stream: db_categories.snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData)
            snapshot.data['categories'].asMap().forEach((i, v) {
              if (v['name'] == widget.catergoty) {
                data = snapshot.data['categories'][i]['list_of_links'];
              }
            });
          var size = MediaQuery.of(context).size;
          return Container(
            padding: EdgeInsets.all(32.0),
            child: GridView.builder(
                itemCount: data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: (size.width / 2) /
                      ((size.height - kToolbarHeight - 24) / 2),
                  crossAxisCount: 3,
                ),
                itemBuilder: (BuildContext context, int index) {
                  dynamic uri = Uri.parse(data[index]['favicon']);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WatchNews(
                                  data[index]['name'], data[index]['link'])));
                    },
                    child: Container(
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            minRadius: 25,
                            maxRadius: 40,
                            backgroundColor: Colors.transparent,
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/image-placeholder.png',
                              width: 40,
                              height: 40,
                              image:
                                  'http://www.google.com/s2/favicons?sz=64&domain=${uri.authority}',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              data[index]['name'],
                              style: TextStyle(fontSize: 18),
                            ),
                          ))
                        ],
                      ),
                    ),
                  );
                }),
          );
        },
      ),
    );
  }
}
