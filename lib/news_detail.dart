/// @Description TODO
/// @Author Johnson
/// @Date 2022/6/11 7:58 下午

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:news_list/utils/widget_ext.dart';

class NewsDetailPage extends StatefulWidget {
  static const route = "/news_detail_page";
  const NewsDetailPage({Key? key, required this.title, required this.id})
      : super(key: key);
  final String title;
  final String id;

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  Map detail = {"title":"","createdAt":"","content":"","createdBy":""};

  _getDetailData() async {
    Uri uri = Uri(
        scheme: 'https',
        host: 'wsy.cosmoplat.com',
        path: 'dev-api/cms/articles/' + widget.id);
    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.getUrl(uri);
    HttpClientResponse response = await request.close();
    //读取响应内容
    String value = await response.transform(utf8.decoder).join();
    //输出响应头
    Map tmpValue = json.decode(value);

    setState(() {
      detail = tmpValue["data"];
      print(detail["title"]);
    });
    //关闭client后，通过该client发起的所有请求都会中止。
    httpClient.close();
  }

  @override
  void initState() {
    super.initState();
    _getDetailData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(child:Column(children: [
        SizedBox.fromSize(size: Size(10, 10)),
        Text(detail["title"],
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF1A1A1A))).setPadding(EdgeInsets.only(left: 10,right: 10)),
        SizedBox.fromSize(size: Size(10, 10)),
        Row(
          children: [
            Text(detail["createdAt"],
                style: TextStyle(fontSize: 13, color: Color(0xFFBABEC3))),
            SizedBox.fromSize(size: Size(10, 10)),
            Text(detail["createdBy"],
                style: TextStyle(fontSize: 13, color: Color(0xFFBABEC3))),
          ],
        ).setPadding(EdgeInsets.only(left: 10,right: 10)),
        SizedBox.fromSize(size: Size(10, 10)),
        Divider(color: Colors.grey,height: 1,),
        SizedBox.fromSize(size: Size(10, 10)),
        Html(data: detail["content"])
        // HtmlRichText(htmlText: detail["content"])
      ]),scrollDirection: Axis.vertical,)

    );
  }

  // Widget _menu() {
  //   return Row(
  //     children: [
  //       TextButton(
  //           child: Text(
  //             '国内新闻',
  //             style: TextStyle(
  //                 fontSize: 15,
  //                 color: listType.compareTo('news.center.domestic')==0
  //                     ? selecttColor
  //                     : defaultColor),
  //           ),
  //           onPressed: () {
  //             listType = 'news.center.domestic';
  //             _getListData();
  //           }).setFlex(),
  //       Container().withSize(
  //           width: 0.1,
  //           height: 30,
  //           decoration: BoxDecoration(
  //               border: Border(
  //                   right: BorderSide(
  //                       color: Color(0xffBABEC3),
  //                       width: 1,
  //                       style: BorderStyle.solid)))),
  //       TextButton(
  //           child: Text('国际新闻',
  //               style: TextStyle(
  //                   fontSize: 15,
  //                   color: listType.compareTo('news.center.world')==0
  //                       ? selecttColor
  //                       : defaultColor)),
  //           onPressed: () {
  //             listType = 'news.center.world';
  //             _getListData();
  //           }).setFlex()
  //     ],
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     mainAxisSize: MainAxisSize.max,
  //   ).withSize(
  //       height: 44,
  //       decoration: BoxDecoration(
  //           border: Border(
  //               bottom: BorderSide(
  //                   color: Color(0xffBABEC3),
  //                   width: 1,
  //                   style: BorderStyle.solid))));
  // }
  //
  // Widget renderItem(BuildContext context, int index, Map data) {
  //   return Container(
  //       child: Column(
  //         children: [
  //           SizedBox.fromSize(size: Size(10, 10)),
  //           Row(
  //             children: [
  //               SizedBox.fromSize(size: Size(10, 10)),
  //               Image(image: NetworkImage(data["imageUrl"]))
  //                   .withSize(width: 80, height: 80),
  //               SizedBox.fromSize(size: Size(10, 10)),
  //               Flexible(
  //                 child: Column(
  //                   children: [
  //                     Text(
  //                       data['title'],
  //                       style: TextStyle(
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 15,
  //                           color: defaultColor),
  //                       maxLines: 2,
  //                       overflow: TextOverflow.ellipsis,
  //                     ),
  //                     SizedBox.fromSize(size: Size(5, 5)),
  //                     Text(
  //                       data['summary'],
  //                       style: TextStyle(fontSize: 12, color: Color(0xFF525A60)),
  //                       maxLines: 3,
  //                       overflow: TextOverflow.ellipsis,
  //                     )
  //                   ],
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                 ),
  //               ),
  //               SizedBox.fromSize(size: Size(10, 10)),
  //             ],
  //           ),
  //           SizedBox.fromSize(size: Size(10, 10)),
  //         ],
  //       ));
  // }
  //
  // Widget _listView() {
  //   return ListView.separated(
  //       itemBuilder: (context, index) {
  //         return _listItemBuilder(context, index);
  //       },
  //       separatorBuilder: (context, index) {
  //         return dividerView(context, index);
  //       },
  //       itemCount: listData.length + 1); //safeArea
  // }
  //
  // Widget _listItemBuilder(context, int index) {
  //   if ((index) < listData.length) {
  //     return renderItem(context, index, listData[index]).setTouchEvent(onTap: (){
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => DeviceDetailPage(deviceNo: device.deviceNo)),
  //       );
  //     });
  //   } else {
  //     //bottom padding
  //     return SizedBox(height: safeAreaBottom());
  //   }
  // }
  //
  // Widget dividerView(BuildContext context, int position) {
  //   return Row(
  //     children: [
  //       Container(
  //         width: 10,
  //         height: 1,
  //         color: Colors.white,
  //       ),
  //       Container(
  //         height: 1,
  //         color: Color(0xFFE9E9E9),
  //       ).setFlex(),
  //       Container(
  //         width: 10,
  //         height: 1,
  //         color: Colors.white,
  //       ),
  //     ],
  //   );
  // }
  //
  // double safeAreaBottom() {
  //   return MediaQuery.of(context).padding.bottom;
  // }
}
