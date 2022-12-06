import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marine_manager/data/data_providers/postgres_data_provider.dart';
import 'package:marine_manager/data/repositories/marine_repo.dart';
import 'package:marine_manager/logic/account_data_cubit/account_data_cubit.dart';
import 'package:marine_manager/logic/app_cubit/app_cubit.dart';
import 'package:marine_manager/logic/container_data_cubit/container_data_cubit.dart';
import 'package:postgres/postgres.dart';

import 'presentation/screens/main_screen.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ContainerDataCubit(MarineRepo.instance()),
        ),
        BlocProvider(
          create: (context) => AccountDataCubit(MarineRepo.instance()),
        ),
        BlocProvider(
          create: (context) => AppCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            if (state is AppRegister) {
              return Text('Register');
            } else if (state is AppLogin) {
              return Text('Login');
            } else {
              return const MainScreen();
            }
          },
        ),
      ),
    );
  }
}
