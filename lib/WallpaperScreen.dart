import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/cupertino.dart';
// import 'package:toast/toast.dart';
import 'package:wallpaper/wallpaper.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

enum wallpaperActions {
  lockScreen,
  homeScreen,
  both,
  cancel
}

Future<String> loadAsset(img) async {
  return await rootBundle.loadString(img);
}

class WallpaperScreen extends StatefulWidget {
  final String imgPath;

  WallpaperScreen(this.imgPath);

  @override
  _WallpaperScreenState createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  String home = 'Home Screen',
        lock = 'Lock Screen',
        both = 'Both Screens';

  Stream<String> progressString;
  Future<String> assetString; // not for production
  String res;
  bool downloading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          wallpaper(context, widget.imgPath),
          Positioned(
              top: 40.0,
              left: 0.0,
              right: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.grey,
                        size: 28.0,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Toast.show('Set as wallpaper', context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        showCupertinoModalPopup(context: context, builder: (BuildContext context) => CupertinoActionSheet(
                          actions: <Widget>[
                            CupertinoActionSheetAction(
                              child: const Text('Home Screen'),
                              onPressed: () {
                                Navigator.pop(context, wallpaperActions.homeScreen);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: const Text('Lock Screen'),
                              onPressed: () {
                                Navigator.pop(context, wallpaperActions.lockScreen);
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: const Text('Both'),
                              onPressed: () {
                                Navigator.pop(context, wallpaperActions.both);
                              },
                            )
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            child: const Text('Cancel'),
                            isDefaultAction: true,
                            onPressed: () {
                              Navigator.pop(context, wallpaperActions.cancel);
                            },
                          ),
                        )).then((action) async {
                          // show loading snackbar
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            duration: Duration(minutes: 5),
                            content: Row(
                              children: <Widget>[
                                CircularProgressIndicator(),
                                SizedBox(width: 15.0,),
                                Text('Please wait...')
                              ],
                            ),
                          ));
                          progressString = Wallpaper.ImageDownloadProgress(widget.imgPath);
                          progressString.listen((data) {
                            setState(() {
                              res = data;
                              downloading = true;
                            });
                          }, onDone: () async {
                            // hide loading snackbar
                            _scaffoldKey.currentState.hideCurrentSnackBar();
                            switch (action) {
                              case wallpaperActions.homeScreen:
                                home = await Wallpaper.homeScreen();
                                setState(() {
                                  downloading = false;
                                  home = home;
                                });
                                break;
                              case wallpaperActions.lockScreen:
                                lock = await Wallpaper.lockScreen();
                                setState(() {
                                  downloading = false;
                                  lock = lock;
                                });
                                break;
                              case wallpaperActions.both:
                                both = await Wallpaper.bothScreen();
                                setState(() {
                                  downloading = false;
                                  both = both;
                                });
                                break;
                              default:
                                return;
                            }
                            final snackBar = SnackBar(
                              content: Text('Wallpaper changed'),
                              action: SnackBarAction(
                                label: 'OK',
                                onPressed: () {
                                  _scaffoldKey.currentState.hideCurrentSnackBar();
                                },
                              ),
                            );
                            if ( action != wallpaperActions.cancel ) {
                              // Toast.show("$onValue wallpaper changed", context);
                              // show success snackbar
                              _scaffoldKey.currentState.showSnackBar(snackBar);
                            }
                          }, onError: (e) {
                            setState(() {
                              downloading = false;
                            });
                            print(e);
                          });
                        });
                      },
                      icon: Icon(
                        Icons.check,
                        color: Colors.grey,
                        size: 30.0,
                      ),
                    ),
                  ],
                ),
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 25.0),
              child: shimmerText(),
            ),
          )
        ],
      ),
    );
  }
}

wallpaper(context, imgPath) {
  return Container(
      height: MediaQuery.of(context).size.height,
      child: Hero(
        tag: imgPath,
        child: FadeInImage(
          image: NetworkImage(imgPath),
          fit: BoxFit.cover,
          placeholder: AssetImage('assets/placeholder.jpg'),
        ),
        // child: Image.network(
        //   imgPath,
        //   fit: BoxFit.cover,
        // ),
      ));
}

Widget shimmerText() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.withOpacity(0.6),
    highlightColor: Colors.white.withOpacity(0.6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.chevron_right,
          size: 30.0,
        ),
        Text(
          'Slide to unlock',
          style: TextStyle(
            fontSize: 25.0,
          ),
        ),
      ],
    ),
  );
}
