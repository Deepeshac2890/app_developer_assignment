import 'dart:convert';

class Tournaments {
  String name;
  String game_name;
  String cover_url;

  Tournaments(
      {required this.cover_url, required this.game_name, required this.name});
}

class parseData {
  String responseBody;

  parseData({required this.responseBody});

  DataNeeded readData() {
    final jsonResponse = json.decode(responseBody);
    var data = jsonResponse['data'];
    String cursor = data['cursor'];
    var tournamentsRawData = data['tournaments'];
    List<Tournaments> listOfTournaments = [];
    for (int i = 0; i < tournamentsRawData.length; i++) {
      Tournaments t = Tournaments(
          cover_url: tournamentsRawData[i]['cover_url'],
          game_name: tournamentsRawData[i]['game_name'],
          name: tournamentsRawData[i]['name']);
      listOfTournaments.add(t);
    }
    DataNeeded dt = DataNeeded(list: listOfTournaments, cursor: cursor);
    return dt;
  }
}

class DataNeeded {
  String cursor;
  List<Tournaments> list;

  DataNeeded({required this.list, required this.cursor});
}
