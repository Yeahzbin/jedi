import 'package:flutter/material.dart';
import 'package:jedi/home/blocks/activity_bar.dart';
import 'package:jedi/home/blocks/featured_segment.dart';
import 'package:jedi/home/blocks/featured_headlines.dart';
import 'package:jedi/home/featured/blocks/large_poster.dart';
import 'package:jedi/home/featured/blocks/hot_list.dart';
import 'package:jedi/home/blocks/recommend_you.dart';
import 'package:jedi/blocks/pulltore_fresh.dart';
import 'package:jedi/internet/api_navigation.dart';

/// 自定义的精选页面组件。
class FeaturedPage extends StatefulWidget {
  @override
  _FeaturedPageState createState() => _FeaturedPageState();
}

/// 与自定义的精选页面组件关联的状态子类。
/// 自动保持活动客户端混合（`AutomaticKeepAliveClientMixin`）抽象类，
/// 为自动保持活动（`AutomaticKeepAlive`）的客户提供方便的方法，与State子类一起使用。
/// 可以避免作为父组件的标签栏视图（`TabBarView`）组件切换时被重新绘制。
class _FeaturedPageState extends State<FeaturedPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  /// 列表视图（`ListView`）中要显示的数据。
  List<Widget> widgetList = [];

  /// 滚动控制器（`ScrollController`）类，控制可滚动的组件。
  ScrollController controller = ScrollController();

  /// 滚动物理（`ScrollPhysics`）类，确定滚动组件的物理特性。
  ScrollPhysics scrollPhysics = RefreshAlwaysScrollPhysics();

  /// 通过按钮等其他方式，通过方法调用触发下拉刷新。
  TriggerPullController triggerPullController = TriggerPullController();

  /// 自动保持活动客户端混合（`AutomaticKeepAliveClientMixin`）抽象类的想要保持活动（`wantKeepAlive`）属性，
  /// 用于设置当前实例是否应保持活动状态（不因父组件的切换而重新绘制）。
  @protected
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // 第一次构建后会被调用。
    WidgetsBinding.instance.addPostFrameCallback((context) {
      triggerPullController.triggerPull();
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// 构建列表视图（`ListView`）中要显示的初始化或常驻内容。
  List<Widget> _buildResidentData({
    List<List<String>> imgList,
    List<SegmentItem> segment,
    List<List<String>> headlines,
    List<String> posterPicture,
  }) {
    return <Widget>[
      ActivityBar(imgList: imgList),
      FeaturedSegment(segment: segment),
      Divider(
        height: 1.0,
        color: Color(0xffE2E2E2),
      ),
      FeaturedHeadlines(headlines: headlines),
      Container(
        height: 10.0,
        color: Color(0xffF6F6F6),
      ),
      LargePoster(posterPicture: posterPicture),
      Container(
        height: 10.0,
        color: Color(0xffF6F6F6),
      ),
      HotList(
        hotData: <HotItem>[
          HotItem(
            objUrl:
                'https://img.alicdn.com/i2/2615650292/O1CN011E1m5zcGXrNqYCH_!!2615650292.png_300x300.jpg',
            title: '抽纸批发整箱30包雪亮家庭装婴儿卫生纸巾家用餐巾纸面巾纸实惠装',
            rebatePrice: 26.99,
            costPrice: 29.99,
            couponPrice: 3.0,
            purchaseNum: 119992,
          ),
          HotItem(
            objUrl:
                'http://logo.taobaocdn.com/shop-logo/ee/a1/TB1AxwhOXXXXXcPapXXwu0bFXXX.png',
            title: '【小魔鲸】A类女童内裤三角裤',
            rebatePrice: 15.5,
            costPrice: 20.5,
            couponPrice: 5.0,
            purchaseNum: 33548,
          ),
          HotItem(
            objUrl: 'http://images.huasheng100.com/public/1553568711182897.png',
            title: '【Miss face】妆前乳美白防晒隔离霜',
            rebatePrice: 74.9,
            costPrice: 89.9,
            couponPrice: 15.0,
            purchaseNum: 62260,
          ),
          HotItem(
            objUrl:
                'https://img.alicdn.com/i4/1097805039/TB2susMuBjTBKNjSZFwXXcG4XXa_!!1097805039.jpg_300x300.jpg',
            title: '网红零食芒果干',
            rebatePrice: 24.9,
            costPrice: 29.9,
            couponPrice: 5.0,
            purchaseNum: 53487,
          ),
          HotItem(
            objUrl:
                'https://img.alicdn.com/bao/uploaded/i2/273162744/O1CN01jd6G541W8nJLZyhRD_!!0-item_pic.jpg_300x300.jpg',
            title: '彼丽空气隐形丝袜液体小泡沫喷雾女喷脖子遮瑕补水定妆买3送防晒',
            rebatePrice: 9.0,
            costPrice: 29.0,
            couponPrice: 20.0,
            purchaseNum: 27845,
          ),
        ],
      ),
      Container(
        height: 10.0,
        color: Color(0xffF6F6F6),
      ),
      RecommendYouTitle(),
    ];
  }

  Future _loadData(bool isPullDown) async {
    if (isPullDown) {
      apiGetGetPagelayout(categoryid: 1).then((_map) {
        List<List<String>> imgList = [];
        List<SegmentItem> segment = [];
        List<List<String>> headlines = [];
        List<String> posterPicture = [];
        for (Map amap in _map) {
          if (amap['type'] == '1') {
            imgList.add(
              [imageurlHeadPagelayout + amap['layoutimage'], amap['clickurl']],
            );
          } else if (amap['type'] == '2') {
            segment.add(
              SegmentItem(
                image: imageurlHeadPagelayout + amap['layoutimage'],
                title: amap['text'],
              ),
            );
          } else if (amap['type'] == '3') {
            headlines.add([amap['text']]);
          } else if (amap['type'] == '4') {
            posterPicture.add(imageurlHeadPagelayout + amap['layoutimage']);
          }
        }
        setState(() {
          widgetList = _buildResidentData(
            imgList: imgList,
            segment: segment,
            headlines: headlines,
            posterPicture: posterPicture,
          );
          widgetList.addAll(recommendYou());
        });
      });
    } else {
      Future.delayed(Duration(milliseconds: 50), () {
        setState(() {
          widgetList.addAll(recommendYou());
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PullAndPush(
      // 简单的配置头部和底部的样式。
      defaultRefreshBoxTipText: '松开将为你刷新数据……',
      defaultRefreshBoxTextColor: Color(0xff666666),
      defaultRefreshBoxBackgroundColor: Color(0xffF6F6F6),
      defaultRefreshBoxRefreshIconPath: 'assets/refresh.png',
      // 可通过此对象的方法调用触发下拉刷新。
      triggerPullController: triggerPullController,
      // 用于上下拉的滑动控件。
      listView: ListView.builder(
        itemCount: widgetList.length,
        controller: controller,
        physics: scrollPhysics,
        itemBuilder: (BuildContext context, int index) {
          return widgetList[index];
        },
      ),
      // 加载数据的回调。
      loadData: (isPullDown) async {
        // `isPullDown`为`true`时表示下拉刷新，为`false`时表示上拉加载。
        await _loadData(isPullDown);
      },
      // 列表视图（`ListView`）组件中的滚动物理（`scrollPhysics`）组件发生改变时回调。
      scrollPhysicsChanged: (ScrollPhysics physics) {
        // 通过`setState()`方法改变列表视图（`ListView`）组件的物理（`Physics`）属性。
        setState(() {
          // 这个不用改，照抄即可。
          scrollPhysics = physics;
        });
      },
    );
  }
}