import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:firebase_admob/firebase_admob.dart';

class WatchNews extends StatefulWidget {
  WatchNews(this.name, this.link);
  final link;
  final name;
  @override
  _WatchNewsState createState() => _WatchNewsState();
}

class _WatchNewsState extends State<WatchNews> {
  Box box = Hive.box('favoritesBox');
  Widget getIcon() {
    if (box.containsKey(widget.link)) {
      return Icon(Icons.favorite, color: Hexcolor('#EE503B'));
    }
    return Icon(Icons.favorite_border);
  }

  BannerAd _bannerAd;

  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId: 'ca-app-pub-4788816498403375/2598519318',
        //Change BannerAd adUnitId with Admob ID
        size: AdSize.smartBanner,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            _bannerAd..show();
          }
          if (event == MobileAdEvent.failedToLoad) {
            print('$event');
          }
        });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-4788816498403375~2708230334');

    _bannerAd = createBannerAd()..load();
  }

  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bannerAd.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: getIcon(),
              onPressed: () async {
                if (box.containsKey(widget.link)) {
                  setState(() {
                    box.delete(widget.link);
                  });
                } else {
                  setState(() {
                    box.put(widget.link, widget.name);
                  });
                }
                box.toMap().forEach((key, value) {
                  print(value);
                });
              })
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.name,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Hexcolor('#465BD2'),
      ),
      body: WebView(
        initialUrl: widget.link,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
