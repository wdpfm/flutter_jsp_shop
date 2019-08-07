import 'package:flutter/material.dart';
import '../service/service_methon.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive=>true;
  String homePageContent = '正在获取数据';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('百姓生活+'),
        ),
        body: FutureBuilder(
          future: getHomePageContent(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = json.decode(snapshot.data.toString());
              List<Map> swiper = (data['data']['slides'] as List).cast();
              List<Map> navigatorList =
                  (data['data']['category'] as List).cast();
              String adPicture =
                  data['data']['advertesPicture']['PICTURE_ADDRESS'];
              String leaderImage = data['data']['shopInfo']['leaderImage'];
              String leaderPhone = data['data']['shopInfo']['leaderPhone'];
              List<Map> recommendList =
                  (data['data']['recommend'] as List).cast();

              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SwiperDiy(
                      swiperDateList: swiper,
                    ),
                    TopNavigator(
                      navigatorList: navigatorList,
                    ),
                    AdBanner(
                      adPicture: adPicture,
                    ),
                    LeaderPhone(leaderImage: leaderImage, leaderPhone: leaderPhone,),
                    Recommend(
                      recommendList: recommendList,
                    )
                  ],
                ),
              );
            } else {
              return Center(
                child: Text(
                  '加载中......',
                  style: TextStyle(fontSize: ScreenUtil().setSp(28)),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

//首页轮播组件
class SwiperDiy extends StatelessWidget {
  final List swiperDateList;

  SwiperDiy({Key key, this.swiperDateList});

  @override
  Widget build(BuildContext context) {
//    print('设备像素密度:${ScreenUtil.pixelRatio}');
//    print('设备的宽:${ScreenUtil.screenWidth}');
//    print('设备的高:${ScreenUtil.screenHeight}');
    return Container(
        height: ScreenUtil().setHeight(333),
        width: ScreenUtil().setWidth(750),
        child: Scaffold(
          body: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return Image.network(
                '${swiperDateList[index]['image']}',
                fit: BoxFit.fill,
              );
            },
            itemCount: swiperDateList.length,
            pagination: SwiperPagination(),
            autoplay: true,
          ),
        ));
  }
}

//类别导航
class TopNavigator extends StatelessWidget {
  final List navigatorList;

  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print('点击了导航');
      },
      child: Column(
        children: <Widget>[
          Image.network(
            item['image'],
            width: ScreenUtil().setWidth(95),
          ),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (this.navigatorList.length > 10) {
      this.navigatorList.removeRange(10, this.navigatorList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navigatorList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

//广告banner
class AdBanner extends StatelessWidget {
  final String adPicture;

  AdBanner({Key key, this.adPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}

//店长电话
class LeaderPhone extends StatelessWidget {
  final String leaderImage;
  final String leaderPhone;

  LeaderPhone({Key key, this.leaderImage, this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          _launcherURL();
        },
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launcherURL() async {
    String url = 'tel:' + leaderPhone;
    //String url = 'http://www.baidu.com';
    print('url------------' + url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'url不能进行访问异常';
    }
  }
}

//商品推荐
class Recommend extends StatelessWidget {
  final List recommendList;

  Recommend({Key key, this.recommendList}) : super(key: key);

  //标题方法
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(
          width: 0.5,
          color: Colors.black12,
        )),
      ),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  //商品单独项方法
  Widget _item(index) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil().setHeight(350),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(left: BorderSide(width: 0.5, color: Colors.black12))),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //横向列表方法
  Widget _recommedList() {
    return Container(
        height: ScreenUtil().setHeight(380),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: recommendList.length,
          itemBuilder: (context, index) {
            return _item(index);
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(440),
      margin: EdgeInsets.only(top: 10.0),
      child: Center(
        child: Column(
          children: <Widget>[
             _titleWidget(),
            _recommedList(),
          ],
        ),
      ),
    );
  }
}
