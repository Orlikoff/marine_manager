import 'package:marine_manager/data/abstractions/data_provider.dart';
import 'package:postgres/postgres.dart';

class PostgresDataProvider implements DataProvider {
  final PostgreSQLConnection connection;

  PostgresDataProvider(this.connection);

  @override
  Future<List<dynamic>> loadQueryResults(String query,
      {Map<String, dynamic>? subValues}) async {
    return await connection.query(query, substitutionValues: subValues);
  }
}
