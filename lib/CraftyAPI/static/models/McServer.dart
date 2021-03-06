// To parse this JSON data, do
//
//     final serverStat = serverStatFromJson(jsonString);

import 'dart:convert';

import 'package:craftycommander/CraftyAPI/craftyAPI.dart';
import 'package:flutter/services.dart';

List<McServer> serverStatFromJson(String str) =>
    List<McServer>.from(json.decode(str).map((x) => McServer.fromJson(x)));

String serverStatToJson(List<McServer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class McServer {
  final int id;
  final int serverId;
  final String serverStartTime;
  final double cpuUsage;
  final String memoryUsage;
  final int maxPlayers;
  final int onlinePlayers;
  final String playersString;
  final String motd;
  final bool serverRunning;
  final String serverVersion;
  final String worldName;
  final String worldSize;
  final String serverIp;
  final int serverPort;
  final String name;

  McServer(
      {this.id,
      this.serverId,
      this.serverStartTime,
      this.cpuUsage,
      this.memoryUsage,
      this.maxPlayers,
      this.onlinePlayers,
      this.playersString,
      this.motd,
      this.serverRunning,
      this.serverVersion,
      this.worldName,
      this.worldSize,
      this.serverIp,
      this.serverPort,
      this.name,});

  factory McServer.fromJson(Map<String, dynamic> json) => McServer(
        id: json["id"],
        serverId: json["server_id"],
        serverStartTime: json["server_start_time"],
        cpuUsage: json["cpu_usage"].toDouble(),
        memoryUsage: json["memory_usage"],
        maxPlayers: json["max_players"],
        onlinePlayers: json["online_players"],
        playersString: json["players"],
        motd: json["motd"],
        serverRunning: json["server_running"],
        serverVersion: json["server_version"],
        worldName: json["world_name"],
        worldSize: json["world_size"],
        serverIp: json["server_ip"],
        serverPort: json["server_port"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "server_id": serverId,
        "server_start_time": serverStartTime,
        "cpu_usage": cpuUsage,
        "memory_usage": memoryUsage,
        "max_players": maxPlayers,
        "online_players": onlinePlayers,
        "players": playersString,
        "motd": motd,
        "server_running": serverRunning,
        "server_version": serverVersion,
        "world_name": worldName,
        "world_size": worldSize,
        "server_ip": serverIp,
        "server_port": serverPort,
        "name": name,
      };

  List<String> getPlayerList() {
    final list =
        _replaceAllChar(['[', ']', '\'', ' '], playersString).split(',');
    if (list.length == 1) if (list[0] == '') return [];
    return list;
  }

  String _replaceAllChar(List<String> fragments, String s) {
    for (var a in fragments) {
      s = s.replaceAll(a, '');
    }
    return s;
  }
}