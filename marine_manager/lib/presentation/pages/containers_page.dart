import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../credentials.dart';
import '../../data/entities/container.dart';
import '../../logic/container_data_cubit/container_data_cubit.dart';
import 'add_container.dart';

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
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: credentials!['marine_worker_id'] == null
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AddContainer(),
                      ),
                    );
                  },
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () async {
                  await BlocProvider.of<ContainerDataCubit>(context)
                      .loadDataContainer();
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
                    itemCount: state.data.length * 2,
                    itemBuilder: (context, index) {
                      if (index % 2 == 1) return const Divider();
                      final ContainerData data = state.data[index ~/ 2];
                      return ListTile(
                        leading: TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: Text(data.containerCode),
                                    content: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Dispatch id: ${data.dispatchPortId}',
                                          ),
                                          Text(
                                            'Destination id: ${data.destinationPortId}',
                                          ),
                                          Text(
                                            'Vessel id: ${data.vesselId}',
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('Okay'),
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            data.containerCode.toString(),
                          ),
                        ),
                        title: Center(
                          child: Text(
                              "In port: ${data.vesselId.toString() == 'null' ? 'Yes' : 'No'}"),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            BlocProvider.of<ContainerDataCubit>(context)
                                .removeContainer(data.id);
                          },
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
