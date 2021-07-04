import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:esp_config/common/localization/default_localizations.dart';
import 'package:esp_config/pages/network/network_page.dart';
import 'package:esp_config/pages/mqtt/mqtt_page.dart';
import 'package:esp_config/pages/devices/devices_page.dart';
import 'package:esp_config/common/common.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

final List<Widget> pages = <Widget>[NetworkPage(), MqttPage(), DevicesPage()];

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, _HomePageCrl {

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    super.build(context);

    _bottomBar = _bottomBar.length>0?  _bottomBar:initBottomBar();
    var homePage = WillPopScope(
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: this.currentIndex,
              onTap: (index) async {
                setState(() {
                  this.currentIndex = index;
                  pageController.jumpToPage(index);
                });
              },
              items: _bottomBar),
          body: _getPageBody(context),
        ),
        onWillPop: () async {
          // 点击返回键的操作
          return true;
        });
    // Application.router.navigateTo(context, '/login_page');
    //initShow();
    return homePage;
  }

    Widget _getPageBody(BuildContext context) {
    return PageView(
      controller: pageController,
      children: pages,
      physics: NeverScrollableScrollPhysics(), // 禁止滑动
    );
  }
}

mixin _HomePageCrl on State<HomePage> {

  final pageController = PageController();
  List<BottomNavigationBarItem> _bottomBar=[];
  int currentIndex = 0;

  @override
  void initState() {
    // initBottomBar();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initBottomBar() {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.wifi),
          title: Text(EspConfigLocalizations.i18n(context)!.network)),
      BottomNavigationBarItem(
          icon: Icon(Icons.sync),
          title: Text(EspConfigLocalizations.i18n(context)!.mqtt)),
      BottomNavigationBarItem(
          icon: Icon(Icons.device_hub),
          title: Text(EspConfigLocalizations.i18n(context)!.devices))
    ];
  }

}
