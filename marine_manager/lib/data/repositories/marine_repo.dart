import 'package:flutter/animation.dart';
import 'package:marine_manager/data/abstractions/data_provider.dart';

class MarineRepo {
  late final DataProvider dataProvider;

  static final MarineRepo _instance = MarineRepo._internal();

  MarineRepo._internal();

  static void init(DataProvider initDataProvider) {
    _instance.dataProvider = initDataProvider;
  }

  factory MarineRepo.instance() {
    return _instance;
  }

  // Functions of repository
  Future<List<List<dynamic>>> loadUsernames() async {
    final List<List<dynamic>> usernamesById = [];
    var data = await dataProvider.loadQueryResults(
        'SELECT id, user_name FROM user_data ORDER BY id ASC;');

    for (final row in data) {
      usernamesById.add([
        row['user_data']!['id'],
        row['user_data']!['user_name'].toString(),
      ]);
    }

    return usernamesById;
  }

  Future<void> changeUsername(int index, String newUsername) async {
    await dataProvider.loadQueryResults(
      'UPDATE user_data SET user_name=@u WHERE id=@i;',
      subValues: {
        'u': newUsername,
        'i': index,
      },
    );
  }

  // Account page functions
  Future<Map<String, dynamic>?> authenticateUser(
    String email,
    String password, {
    VoidCallback? onWrongCreds,
  }) async {
    final Map<String, dynamic> userCredentials = {};
    var data = await dataProvider.loadQueryResults(
        'SELECT * FROM user_data WHERE user_email=@e AND user_password=@p;',
        subValues: {
          'e': email,
          'p': password,
        });

    if (data.isNotEmpty) {
      for (final row in data) {
        var tableData = row['user_data']!;
        userCredentials['id'] = tableData['id'];
        userCredentials['user_name'] = tableData['user_name'];
        userCredentials['user_surname'] = tableData['user_surname'];
        userCredentials['user_email'] = tableData['user_email'];
        userCredentials['user_password'] = tableData['user_password'];
      }

      data = await dataProvider.loadQueryResults(
          "SELECT * FROM app_user WHERE user_data_id=@i AND user_role='worker';",
          subValues: {
            'i': userCredentials['id'],
          });

      if (data.isNotEmpty) {
        for (final row in data) {
          var tableData = row['app_user']!;
          userCredentials['user_role'] = tableData['user_role'];
          userCredentials['marine_worker_id'] = tableData['marine_worker_id'];
        }

        data = await dataProvider.loadQueryResults(
            "SELECT * FROM marine_worker WHERE id=@i;",
            subValues: {
              'i': userCredentials['marine_worker_id'],
            });

        if (data.isNotEmpty) {
          for (final row in data) {
            var tableData = row['marine_worker']!;
            userCredentials['company_name'] = tableData['company_name'];
            userCredentials['country_of_origin'] =
                tableData['country_of_origin'];
          }
        }
      } else {
        userCredentials['user_role'] = 'user';
        userCredentials['marine_worker_id'] = null;
        userCredentials['company_name'] = null;
        userCredentials['country_of_origin'] = null;
      }
    }

    if (userCredentials.isEmpty) {
      if (onWrongCreds != null) {
        onWrongCreds();
      }
      return null;
    }

    return userCredentials;
  }

  Future<List<List<dynamic>>> loadUserInfoByEmail(String email) async {
    final List<List<dynamic>> usernamesById = [];
    var data = await dataProvider.loadQueryResults(
        'SELECT id, user_name FROM user_data ORDER BY id ASC;');

    for (final row in data) {
      usernamesById.add([
        row['user_data']!['id'],
        row['user_data']!['user_name'].toString(),
      ]);
    }

    return usernamesById;
  }
}
