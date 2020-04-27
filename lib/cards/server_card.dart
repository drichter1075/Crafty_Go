import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServerCard extends StatelessWidget {
  String name, type, motd, started, autoStart, players;
  int ram, cpu;
  final TextStyle textStyle = new TextStyle(
    color: Colors.white,
    fontSize: 20,
  );
  final TextStyle sTextStyle = new TextStyle(color: Colors.white, fontSize: 15);

  ServerCard(
      {Key key,
      this.name,
      this.type,
      this.motd,
      this.started,
      this.autoStart,
      this.ram,
      this.cpu,
      this.players})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    name = name ?? "Name is empty";
    type = name ?? "empty";
    motd = motd ?? "empty";
    started = started ?? "Started: empty";
    autoStart = autoStart ?? "unknow";
    players = players ?? "0/0";
    ram = ram ?? 0;
    cpu = cpu ?? 0;

    return Container(
      padding: EdgeInsets.all(5),
      height: 200,
      decoration: BoxDecoration(
        boxShadow: [
          new BoxShadow(
            color: Colors.black.withOpacity(0.8),
            blurRadius: 10.0,
          ),
        ],
        border: Border.all(color: true ? Colors.green : Colors.red, width: 4),
        borderRadius: BorderRadius.all(Radius.circular(23)),
        image: DecorationImage(
            image: AssetImage("images/backgroundSample.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4), BlendMode.darken)),
      ),
      margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _DesignContainer(
            color: Colors.blue.withOpacity(0.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  name,
                  style: textStyle,
                ),
                Text(
                  players,
                  style: textStyle,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _DesignContainer(
                color: Colors.blueGrey.withOpacity(0.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      started,
                      style: sTextStyle,
                    ),
                    Text(
                      motd,
                      style: sTextStyle,
                    ),
                    Text(
                      type,
                      style: sTextStyle,
                    ),
                    Text(
                      autoStart,
                      style: sTextStyle,
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  _IconAndText(
                    icon: Icons.apps,
                    text: ram.toString() + "%",
                    backgroundColor: Colors.deepPurpleAccent.withOpacity(0.5),
                    textStyle: sTextStyle,
                  ),
                  _IconAndText(
                    icon: Icons.memory,
                    text: cpu.toString() + "%",
                    backgroundColor: Colors.deepPurpleAccent.withOpacity(0.5),
                    textStyle: sTextStyle,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DesignContainer extends StatelessWidget {
  final Widget child;
  final Color color;

  const _DesignContainer({Key key, this.child, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)), color: color),
      child: child,
    );
  }
}

class _IconAndText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color backgroundColor;
  final TextStyle textStyle;

  const _IconAndText(
      {Key key, this.icon, this.text, this.backgroundColor, this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _DesignContainer(
      color: backgroundColor,
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: textStyle.color,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: textStyle,
          )
        ],
      ),
    );
  }
}