import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'WallpaperScreen.dart';

void main() => runApp(MyApp());

final List<String> wallpaperList = [
  'https://raw.githubusercontent.com/Shubh-Sharma/wallpapers_demo/master/assets/wallpaper-1.png',
  'https://raw.githubusercontent.com/Shubh-Sharma/wallpapers_demo/master/assets/wallpaper-2.png',
  'https://raw.githubusercontent.com/Shubh-Sharma/wallpapers_demo/master/assets/wallpaper-3.png',
  'https://raw.githubusercontent.com/Shubh-Sharma/wallpapers_demo/master/assets/wallpaper-4.png'
  // 'assets/wallpaper-2.png',
  // 'assets/wallpaper-3.png',
  // 'assets/wallpaper-4.png'
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallpapers App',
      theme: ThemeData(
          accentColor: Color(0xFF6959BF), brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
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
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: WallpaperScreen(wallpaperList[0]),
    // );
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            top: 50.0,
            left: 20.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Wallpapers',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0
                  ),
                ),
                SizedBox(height: 8.0,),
                Text(
                  "${wallpaperList.length} WALLPAPERS AVAILABLE",
                  style: TextStyle(
                    color: Colors.white54,
                    // fontFamily: 'Montserrat',
                    fontFamily: 'OpenSans',
                    // fontWeight: FontWeight.w400,
                    fontSize: 11.0
                  ),
                ),
              ],
            ),
          ),
          StaggeredGridView.countBuilder(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 128.0),
            crossAxisCount: 4,
            itemCount: wallpaperList.length,
            itemBuilder: (context, index) {
              String imgPath = wallpaperList[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WallpaperScreen(imgPath)));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Hero(
                    tag: imgPath,
                    child: FadeInImage(
                      image: NetworkImage(imgPath),
                      fit: BoxFit.cover,
                      placeholder: AssetImage('assets/placeholder.svg'),
                    ),
                  ),
                ),
              );
            },
            staggeredTileBuilder: (i) =>
                new StaggeredTile.count(2, i.isEven ? 2 : 3),
            mainAxisSpacing: 20.0,
            crossAxisSpacing: 20.0,
          ),
        ],
      ),
    );
  }
}
