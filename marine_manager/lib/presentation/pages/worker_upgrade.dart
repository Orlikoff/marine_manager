import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/account_data_cubit/account_data_cubit.dart';
import '../../logic/app_cubit/app_cubit.dart';

class WorkerUpgrade extends StatefulWidget {
  const WorkerUpgrade({super.key});

  @override
  State<WorkerUpgrade> createState() => _WorkerUpgradeState();
}

class _WorkerUpgradeState extends State<WorkerUpgrade> {
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade to worker'),
      ),
      body: Center(
        child: Form(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Upgrade to worker',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _companyController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: 'Company',
                    fillColor: Colors.white70),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _countryController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: 'Country',
                    fillColor: Colors.white70),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () async {
                        if (_companyController.text.isEmpty ||
                            _countryController.text.isEmpty) {
                          _displaySnackbar('Fill all the fields');
                          return;
                        }

                        await BlocProvider.of<AccountDataCubit>(context)
                            .upgradeToWorker(
                          _companyController.text,
                          _countryController.text,
                        );

                        if (mounted) Navigator.of(context).pop();
                      },
                      child: const Text('Upgrade to worker'),
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                BlocProvider.of<AppCubit>(context).register();
              },
              child: const Text('Do bot have account?'),
            ),
          ],
        )),
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

  @override
  void dispose() {
    _companyController.dispose();
    _countryController.dispose();
    super.dispose();
  }
}
