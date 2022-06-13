/// @Description TODO
/// @Author Johnson
/// @Date 2022/6/11 5:08 下午
///

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:news_list/utils/widget_ext.dart';
import 'package:news_list/news_detail.dart';

class NewsListPage extends StatefulWidget {
  static const route = "/news_page";
  const NewsListPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  String listType =
      'news.center.domestic'; //news.center.domestic国内新闻，news.center.world国际新闻
  int page = 1;
  Color selecttColor = Color(0xff2B81FF);
  Color defaultColor = Color(0xff242629);
  List listData = List.empty(growable: true);
  int totalNum = 0;

  ScrollController _scrollController = ScrollController();

  _getListData() async {
    Uri uri = Uri(
        scheme: 'https',
        host: 'wsy.cosmoplat.com',
        path: 'dev-api/cms/articles/page/',
        queryParameters: {
          'cateCode': listType,
          'pageNo': page.toString(),
          'pageSize': '10'
        });
    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.getUrl(uri);
    HttpClientResponse response = await request.close();
    String value = await response.transform(utf8.decoder).join();
    Map tmpValue = json.decode(value);
    this.totalNum = tmpValue["data"]["total"];

    setState(() {
      if(this.page == 1) {
        this.listData.clear();
        this.listData = tmpValue["data"]["records"];

      }else {
        List tmpList = List.from(tmpValue["data"]["records"]);
        this.listData.addAll(tmpList);
      }

    });
    httpClient.close();
  }

  @override
  void initState() {
    super.initState();
    _getListData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("add");
        if (this.totalNum >= this.listData.length) {
          print("do");
          this.page ++;
          _getListData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(children: [_menu(), _listView().setFlex()]),
    );
  }

  Widget _menu() {
    return Row(
      children: [
        TextButton(
                child: Text(
                  '国内新闻',
                  style: TextStyle(
                      fontSize: 15,
                      color: listType.compareTo('news.center.domestic')==0
                          ? selecttColor
                          : defaultColor),
                ),
                onPressed: () {
                  listType = 'news.center.domestic';
                  _getListData();
                }).setFlex(),
        Container().withSize(
            width: 0.1,
            height: 30,
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(
                        color: Color(0xffBABEC3),
                        width: 1,
                        style: BorderStyle.solid)))),
        TextButton(
                child: Text('国际新闻',
                    style: TextStyle(
                        fontSize: 15,
                        color: listType.compareTo('news.center.world')==0
                            ? selecttColor
                            : defaultColor)),
                onPressed: () {
                  listType = 'news.center.world';
                  _getListData();
                }).setFlex()
      ],
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
    ).withSize(
        height: 44,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: Color(0xffBABEC3),
                    width: 1,
                    style: BorderStyle.solid))));
  }

  Widget renderItem(BuildContext context, int index, Map data) {
    return Container(
        child: Column(
          children: [
            SizedBox.fromSize(size: Size(10, 10)),
            Row(
              children: [
                SizedBox.fromSize(size: Size(10, 10)),
                Image(image: NetworkImage(data["imageUrl"]))
                    .withSize(width: 80, height: 80),
                SizedBox.fromSize(size: Size(10, 10)),
                Flexible(
                  child: Column(
                    children: [
                      Text(
                        data['title'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: defaultColor),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox.fromSize(size: Size(5, 5)),
                      Text(
                        data['summary'],
                        style: TextStyle(fontSize: 12, color: Color(0xFF525A60)),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
                SizedBox.fromSize(size: Size(10, 10)),
              ],
            ),
            SizedBox.fromSize(size: Size(10, 10)),
          ],
        ));
  }

  Widget _listView() {
    return ListView.separated(
        itemBuilder: (context, index) {
          return _listItemBuilder(context, index);
        },
        controller: _scrollController,
        physics: ScrollPhysics(),
        separatorBuilder: (context, index) {
          return dividerView(context, index);
        },
        itemCount: listData.length + 1); //safeArea
  }

  Widget _listItemBuilder(context, int index) {
    if ((index) < listData.length) {
      Map data = listData[index];
      return renderItem(context, index, listData[index]).setTouchEvent(onTap: (){
        // Navigator.pushNamed(context, NewsDetailPage.route);
        Navigator.push(
          context,
            // NewsDetailPage.route,
          MaterialPageRoute(
              builder: (context) => NewsDetailPage(title: '新闻详情',id: data["id"])),
        );
      });
    } else {
      //bottom padding
      return SizedBox(height: safeAreaBottom());
    }
  }

  Widget dividerView(BuildContext context, int position) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 1,
          color: Colors.white,
        ),
        Container(
          height: 1,
          color: Color(0xFFE9E9E9),
        ).setFlex(),
        Container(
          width: 10,
          height: 1,
          color: Colors.white,
        ),
      ],
    );
  }

  double safeAreaBottom() {
    return MediaQuery.of(context).padding.bottom;
  }
}
