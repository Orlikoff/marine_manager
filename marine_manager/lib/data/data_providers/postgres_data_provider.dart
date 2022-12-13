import '../abstractions/data_provider.dart';
import 'package:postgres/postgres.dart';

class PostgresDataProvider implements DataProvider {
  final PostgreSQLConnection connection;

  PostgresDataProvider(this.connection);

  @override
  Future<List<Map<String, Map<String, dynamic>>>> loadQueryResults(String query,
      {Map<String, dynamic>? subValues}) async {
    return await connection.mappedResultsQuery(query,
        substitutionValues: subValues);
  }
}
