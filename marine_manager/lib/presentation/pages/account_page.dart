import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marine_manager/presentation/pages/change_password.dart';
import 'package:marine_manager/presentation/pages/worker_upgrade.dart';
import '../../credentials.dart';
import '../../logic/account_data_cubit/account_data_cubit.dart';
import '../../logic/app_cubit/app_cubit.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final TextTheme theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'User information:',
                  style: theme.headline4,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Name:',
                  style: theme.titleLarge,
                ),
                Text(
                  credentials!['user_name'].toString(),
                  style: theme.titleLarge?.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Surname:',
                  style: theme.titleLarge,
                ),
                Text(
                  credentials!['user_surname'].toString(),
                  style: theme.titleLarge?.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Email:',
                  style: theme.titleLarge,
                ),
                Text(
                  credentials!['user_email'].toString(),
                  style: theme.titleLarge?.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Role:',
                  style: theme.titleLarge,
                ),
                Text(
                  credentials!['user_role'].toString(),
                  style: theme.titleLarge?.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Company name:',
                  style: theme.titleLarge,
                ),
                BlocBuilder<AccountDataCubit, AccountDataState>(
                  builder: (context, state) {
                    if (state is AccountDataChanged) {
                      return Text(
                        credentials!['company_name'].toString(),
                        style: theme.titleLarge?.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                      );
                    }
                    return Text(
                      credentials!['company_name'].toString(),
                      style: theme.titleLarge?.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Country:',
                  style: theme.titleLarge,
                ),
                BlocBuilder<AccountDataCubit, AccountDataState>(
                  builder: (context, state) {
                    if (state is AccountDataChanged) {
                      return Text(
                        credentials!['country_of_origin'].toString(),
                        style: theme.titleLarge?.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                      );
                    }
                    return Text(
                      credentials!['country_of_origin'].toString(),
                      style: theme.titleLarge?.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ChangePassword(),
                      ),
                    );
                  },
                  child: const Text('Change password'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    BlocProvider.of<AppCubit>(context).login();
                  },
                  child: const Text('Log out'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    BlocProvider.of<AccountDataCubit>(context).removeAccount();
                  },
                  child: const Text('Delete account'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: credentials!['country_of_origin'] == null
                        ? () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const WorkerUpgrade(),
                              ),
                            );
                          }
                        : null,
                    child: const Text('Upgrade to worker'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _displaySnackbar(String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      content: Text(message),
    ));
  }
}
