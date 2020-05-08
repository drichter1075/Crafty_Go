import 'dart:async';
import 'dart:convert';

import 'package:craftycommander/CraftyAPI/craftyAPI.dart';
import 'package:craftycommander/CraftyAPI/static/models/hotstStat.dart';
import 'package:craftycommander/CraftyAPI/static/models/serverStat.dart';
import 'package:craftycommander/cards/host_card.dart';
import 'package:craftycommander/cards/server_card.dart';
import 'package:craftycommander/screens/server_config_screen.dart';
import 'package:craftycommander/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/dialogs.dart';

class ServersScreen extends StatefulWidget {
  @override
  _ServersScreenState createState() => _ServersScreenState();
}

class _ServersScreenState extends State<ServersScreen> {
  CraftyClient client;
  List<ServerStat> _serverStats = [];
  HostStat _hostStat;
  List<String> someImages;

  @override
  void initState() {
    initAsync();
    super.initState();
    Timer.periodic(Duration(seconds: 10), (Timer t) {
      if (!this.mounted) {
        t.cancel();
        return;
      }
      if (null == client) return;
        _updateServerStats();
    });
  }


  void initAsync() async {
     _refreshURL();
     _initImages();
  }

  Future<void> _onSettingsClicked() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await utils.openDialog(context,SettingsDialog(prefs),false);
    _refreshURL();
  }

  Future<void> _refreshURL() async {
    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString('apiKey');
    final url = prefs.getString('url');
    if (url == null || url.length < 1 || apiKey == null || apiKey.length < 30) {
      _onSettingsClicked();
    } else {
      client = new CraftyClient(apiKey, url);
      _updateServerStats();
    }
  }

  void _updateServerStats() async {
    if (client == null) {
      _refreshController.refreshFailed();
      return;
    }
    try {
      _serverStats = (await client.getServerStats());
      _hostStat = (await client.getHostStats());
    }catch (e){
      utils.msgToUser(e.toString(), true);
      _refreshController.refreshFailed();
    }
    _refreshController.refreshCompleted();
    setState(() {});
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  Future _initImages() async {
    final manifestContent =
    await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('images/ServerCardImgs/'))
        .toList();
    setState(() {
      someImages = imagePaths;
    });
  }

  Widget serverCardBuilder(BuildContext context, int index) {
    ServerStat stat = _serverStats[index];
    int i;
    if (index > someImages.length) {
      i = someImages.length;
    } else {
      i = index;
    }

    return new ServerCard(
      stat: stat,
      background: AssetImage(someImages[i]),
      onTap: () => _openServerConfigScreen(stat, AssetImage(someImages[i])),
    );
  }

  void _openServerConfigScreen(ServerStat stat, ImageProvider provider) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ServerConfigScreen(client, stat, provider)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SmartRefresher(
            controller: _refreshController,
            onRefresh: _updateServerStats,
            header: WaterDropMaterialHeader(distance: 35),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: 150.0,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        height: 150,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.cyan, width: 4),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30)),
                            image: DecorationImage(
                                image: AssetImage("images/clouds.jpg"),
                                fit: BoxFit.cover)),
                        child: Center(
                            child: HostStatCard(
                              stat: _hostStat,
                              onTapSettings: _onSettingsClicked,
                            )),
                      )),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(serverCardBuilder,
                      childCount: _serverStats.length),
                )
              ],
            )),
      ),
    );
  }
}
