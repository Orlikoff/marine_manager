abstract class DataProvider {
  Future<List<dynamic>> loadQueryResults(String query,
      {Map<String, dynamic>? subValues});
}
