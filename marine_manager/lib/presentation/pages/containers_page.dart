import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marine_manager/logic/container_data_cubit/container_data_cubit.dart';

class ContainersPage extends StatefulWidget {
  const ContainersPage({super.key});

  @override
  State<ContainersPage> createState() => _ContainersPageState();
}

class _ContainersPageState extends State<ContainersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Containers'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () async {
                  await BlocProvider.of<ContainerDataCubit>(context).loadData();
                },
                child: const Text('Fetch data'),
              ),
            ],
          ),
          BlocBuilder<ContainerDataCubit, ContainerDataState>(
            builder: (context, state) {
              if (state is ContainerDataLoading) {
                return const CircularProgressIndicator();
              } else if (state is ContainerDataChanged) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.data.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async =>
                            BlocProvider.of<ContainerDataCubit>(context)
                                .changeUsername(
                          state.data.elementAt(index)[0],
                          'newUsername${state.data.elementAt(index)[1]}',
                          onError: () => _displaySnackbar(
                              'Check length of username: max is 30'),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(3),
                          height: 50,
                          color: Colors.amber,
                          child: Text(state.data.elementAt(index)[1]),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const Text('Empty');
              }
            },
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
