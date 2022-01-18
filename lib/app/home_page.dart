import 'package:flutter/material.dart';
import 'package:time_tracker/app/account/account_page.dart';
import 'package:time_tracker/app/components/cupertinoHomeScaffold.dart';
import 'package:time_tracker/app/components/tabItem.dart';
import 'package:time_tracker/app/home/entries/entries_page.dart';
import 'package:time_tracker/app/home/jobs_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.jobs;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.jobs: GlobalKey<NavigatorState>(),
    TabItem.entries: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.jobs: (_) => JobsPage(),
      TabItem.entries: (_) => EntriesPage.create(context),
      TabItem.account: (_) => AccountPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
      !await navigatorKeys[_currentTab]!.currentState!.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }

  void _select(TabItem value) {
    if (value == _currentTab) {
      navigatorKeys[value]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentTab = value;
      });
    }
  }
}
