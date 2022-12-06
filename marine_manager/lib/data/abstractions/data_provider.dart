abstract class DataProvider {
  Future<List<Map<String, Map<String, dynamic>>>> loadQueryResults(String query,
      {Map<String, dynamic>? subValues});
}
