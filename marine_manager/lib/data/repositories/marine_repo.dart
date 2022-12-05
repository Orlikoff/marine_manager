import 'package:bloc/bloc.dart';
import 'package:marine_manager/data/abstractions/data_provider.dart';
import 'package:marine_manager/logic/data_cubit/data_cubit_api.dart';

class MarineRepo implements MarineData {
  late final DataProvider dataProvider;

  static final MarineRepo _instance = MarineRepo._internal();

  MarineRepo._internal();

  static void init(DataProvider initDataProvider) {
    _instance.dataProvider = initDataProvider;
  }

  factory MarineRepo.instance() {
    return _instance;
  }

  @override
  Future<List<dynamic>> loadUsernames() async {
    return await dataProvider
        .loadQueryResults('SELECT user_name FROM user_data ORDER BY id ASC;');
  }

  @override
  Future<void> changeUsername(int index, String newUsername) async {
    await dataProvider.loadQueryResults(
      'UPDATE user_data SET user_name=@u WHERE id=@i;',
      subValues: {
        'u': newUsername,
        'i': index,
      },
    );
  }
}
