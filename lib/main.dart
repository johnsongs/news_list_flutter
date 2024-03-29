import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:news_list/news_list.dart';
import 'package:news_list/news_detail.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '新闻',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      routes: {
        NewsListPage.route: (context) => const NewsListPage(title: '新闻列表'),
        // NewsDetailPage.route: (context) => const NewsDetailPage(title: '新闻详情'),
      },
      home: const NewsListPage(title: '新闻列表'),
      initialRoute: NewsListPage.route,
    );
  }
}


