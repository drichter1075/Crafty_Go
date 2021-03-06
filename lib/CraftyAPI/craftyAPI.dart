import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:craftycommander/CraftyAPI/static/models/McServer.dart';
import 'package:craftycommander/CraftyAPI/static/models/hotstStat.dart';
import 'package:craftycommander/CraftyAPI/static/models/log_line.dart';
import 'package:craftycommander/CraftyAPI/static/routes.dart' as routes;
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class CraftyClient {
  final String API_TOKEN;
  final String URL;
  final HttpClient httpClient = new HttpClient();
  final bool checkCert;

  factory CraftyClient.fromJson(Map<String, dynamic> json) {
    return CraftyClient(json['API_TOKEN'], json['URL'], json['cert']);
  }
  Map<String, dynamic> toJson() => {
    'API_TOKEN': API_TOKEN,
    'URL': URL,
    'cert': checkCert,
  };

  CraftyClient(this.API_TOKEN, this.URL, this.checkCert) {
    // anwser to certificate: https://stackoverflow.com/questions/49839729/how-to-post-data-to-https-server-in-dart
    httpClient.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => !checkCert);
  }


  Future<String> _makeGetRequest(String apiRoute, Map<String, String> params) async {
    if (params == null) params = Map();
    params.addAll({"token": API_TOKEN});
    var uri = Uri.https(URL, apiRoute, params);
    IOClient ioClient = new IOClient(httpClient);
    http.Response response= await ioClient.get(uri);
    //log(response.body);
    return response.body;
  }

  Future<String> _makePostRequest(String apiRoute,
      Map<String, String> params, [Map<String, String> body]) async {
    if (params == null) params = Map();
    params.addAll({"token": API_TOKEN});
    var uri = Uri.https(URL, apiRoute, params,);
    IOClient ioClient = new IOClient(httpClient);
    http.Response response = await ioClient.post(uri, body: body);
    // todo Close the connection idk when 
    log(json.decode(response.body)['errors'].toString());
    return response.body;
  }

  Future<List<McServer>> getServerStats() async {
    final String response =
    await _makeGetRequest(routes.CraftyAPIRoutes.SERVER_STATS, null);
    final decodedResponse= json.decode(response);
    return serverStatFromJson(jsonEncode(decodedResponse['data']));
  }

  Future<HostStat> getHostStats() async {
    final String response =
    await _makeGetRequest(routes.CraftyAPIRoutes.HOST_STATS, null);
    final decodedResponse= json.decode(response);
    return hostStatFromJson(jsonEncode(decodedResponse['data']));
  }

  Future<dynamic> startServer(int serverId) async {
    final response = await _makePostRequest(
        routes.MCAPIRoutes.START, {'id': serverId.toString()});
    return json.decode(response);
  }

  Future<dynamic> stopServer(int serverId) async {
    final response = await _makePostRequest(
        routes.MCAPIRoutes.STOP, {'id': serverId.toString()});
    return json.decode(response);
  }

  Future<dynamic> restartServer(int serverId) async {
    final response = await _makePostRequest(
        routes.MCAPIRoutes.RESTART, {'id': serverId.toString()});
    return json.decode(response);
  }
  Future<List<LogLine>> getServerLogs(int serverId) async{
    final response = await _makeGetRequest(
        routes.MCAPIRoutes.GET_LOGS, {'id': serverId.toString()});
    final decodedResponse= json.decode(response);
    return logLineFromJson(json.encode(decodedResponse['data']));
  }

  Future<bool> runCommand(int serverId,String command)async{
    final response = await _makePostRequest(
        routes.MCAPIRoutes.SEND_CMD, {'id': serverId.toString()},
        {'command': command});
    return response==null;
  }


}

