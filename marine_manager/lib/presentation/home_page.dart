import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marine_manager/logic/data_cubit/data_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marine manager'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () async {
                  await BlocProvider.of<DataCubit>(context).loadData();
                },
                child: const Text('Fetch data'),
              ),
            ],
          ),
          BlocBuilder<DataCubit, DataState>(
            builder: (context, state) {
              if (state is DataLoading) {
                return const CircularProgressIndicator();
              } else if (state is DataChanged) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.data.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async =>
                            BlocProvider.of<DataCubit>(context).changeUsername(
                          index,
                          'newUsername${state.data.elementAt(index)[0].toString()}',
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(3),
                          height: 50,
                          color: Colors.amber,
                          child:
                              Text(state.data.elementAt(index)[0].toString()),
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
}
