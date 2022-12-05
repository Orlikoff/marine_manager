import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marine_manager/data/data_providers/postgres_data_provider.dart';
import 'package:marine_manager/data/repositories/marine_repo.dart';
import 'package:marine_manager/logic/data_cubit/data_cubit.dart';
import 'package:postgres/postgres.dart';

import 'presentation/home_page.dart';

Future<void> main() async {
  // Setup postgres
  var connection = PostgreSQLConnection(
    '10.0.2.2',
    5432,
    'cargo_manager',
    username: 'postgres',
    password: 'postgre',
  );
  await connection.open();

  // Init repo for database
  MarineRepo.init(PostgresDataProvider(connection));

  // Run app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DataCubit(MarineRepo.instance()),
      child: const MaterialApp(
        title: 'Flutter Demo',
        home: HomePage(),
      ),
    );
  }
}
