import 'dart:async';

import 'package:craftycommander/CraftyAPI/player_manager.dart';
import 'package:craftycommander/globals.dart' as globals;
import 'package:craftycommander/screens/server_config_screen.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:transparent_image/transparent_image.dart';

class PlayersScreen extends StatefulWidget {
  final int serverId;

  PlayersScreen(this.serverId);
  @override
  _PlayersScreenState createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  PlayerManager _playerManager;
  bool selecting = false;
  List<String> players;
  final _refreshController = new RefreshController();
  //the form of the players string: "['test', 'Protocoll']"
  @override
  void initState() {
    players = [
      'asd',
      'nani',
      'ajsdj',
      'asd',
      'nani',
      'ajsdj',
      'asd',
      'nani',
      'ajsdj',
      'test'
    ]; //globals.user.getServersStatById(widget.serverId).getPlayerList();
    _playerManager = new PlayerManager(widget.serverId, globals.user.client);
    super.initState();
    Timer.periodic(Duration(seconds: 10), (Timer t) {
      if (!this.mounted) {
        t.cancel();
        return;
      }
      _updatePlayers();
    });
  }

  void _updatePlayers() async {
    await globals.user.updateServerStats();
    players = [
      'asd',
      'nani',
      'ajsdj',
      'asd',
      'nani',
      'ajsdj',
      'asd',
      'nani',
      'ajsdj',
      'test'
    ]; //globals.user.getServersStatById(widget.serverId).getPlayerList();
    setState(() {
      selecting = !selecting;
    });
    _refreshController.refreshCompleted();
  }

  Widget _builder(BuildContext context, int index) {
    if (index > players.length - 1)
      return SizedBox(
        height: 100,
      );
    return _PlayerListItem(players[index]);
  }

  @override
  Widget build(BuildContext context) {
    final serverStat = globals.user.getServersStatById(widget.serverId);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              'Online players: ${serverStat.onlinePlayers}/${serverStat.maxPlayers}'),
          backgroundColor: Colors.orange,
        ),
        body: Stack(
          children: <Widget>[
            SmartRefresher(
              controller: _refreshController,
              onRefresh: _updatePlayers,
              child: ListView.builder(
                itemBuilder: _builder,
                itemCount: selecting ? players.length + 1 : players.length,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedCrossFade(
                secondChild: Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                        child: Wrap(children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              SettingButton(
                                iconData: Icons.offline_bolt,
                                text: 'OP',
                                color: Colors.blue,
                                size: 18,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SettingButton(
                                iconData: Icons.remove_circle_outline,
                                text: 'DE-OP',
                                color: Colors.blue,
                                size: 18,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SettingButton(
                                iconData: Icons.close,
                                text: "kick",
                                color: Colors.yellow,
                                size: 18,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SettingButton(
                                iconData: Icons.warning,
                                text: "Kill",
                                color: Colors.red,
                                size: 18,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SettingButton(
                                iconData: Icons.delete,
                                text: "ban",
                                color: Colors.red,
                                iconColor: Colors.black,
                                size: 18,
                              ),
                            ],
                          ),
                        ]),
                  ),
                ),
                firstChild: Container(width: 500,),
                crossFadeState: selecting
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: Duration(milliseconds: 1000),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerListItem extends StatefulWidget {
  final String playerName;

  const _PlayerListItem(this.playerName, {Key key}) : super(key: key);

  @override
  __PlayerListItemState createState() => __PlayerListItemState();
}

class __PlayerListItemState extends State<_PlayerListItem> {
  bool opened = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          opened = !opened;
        });
      },
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.5),
          border: Border.all(color: Colors.orange),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                widget.playerName,
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage.memoryNetwork(
                image: "https://minotar.net/avatar/${widget.playerName}/50.png",
                fadeInCurve: Curves.fastOutSlowIn,
                width: 50,
                placeholder: kTransparentImage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
