import 'package:app_developer_assignment/model/customRecommendationModel.dart';
import 'package:http/http.dart' as http;

import '../Resources/StringConstants.dart';

class RecommendationService {
  String cursor = "";

  Future<List<Tournaments>?> getTournaments(String cursor, String limit) async {
    String url = "$urlStart?limit=$limit&status=all";
    if (cursor.isNotEmpty) {
      url = url + "&cursor=$cursor";
    }
    print("This is url : $url");
    var uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      parseData pd = parseData(responseBody: response.body);
      DataNeeded dt = pd.readData();
      this.cursor = dt.cursor;
      return dt.list;
    } else {
      print("The service is Down and response code is : " +
          response.statusCode.toString());
      return null;
    }
  }
}
