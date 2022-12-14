import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/entities/vessel.dart';
import '../../logic/ship_data_cubit/ship_data_cubit.dart';
import 'add_ship.dart';
import '../../credentials.dart';
import '../../data/entities/container.dart';
import '../../logic/container_data_cubit/container_data_cubit.dart';

class ShipsPage extends StatefulWidget {
  const ShipsPage({super.key});

  @override
  State<ShipsPage> createState() => _ShipsPageState();
}

class _ShipsPageState extends State<ShipsPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ships'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: credentials!['marine_worker_id'] == null
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AddShip(),
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
                  await BlocProvider.of<ShipDataCubit>(context).loadShip();
                },
                child: const Text('Fetch data'),
              ),
            ],
          ),
          BlocBuilder<ShipDataCubit, ShipDataState>(
            builder: (context, state) {
              if (state is ContainerDataLoading) {
                return const CircularProgressIndicator();
              } else if (state is ShipDataChanged) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.data.length * 2,
                    itemBuilder: (context, index) {
                      if (index % 2 == 1) return const Divider();
                      final VesselData data = state.data[index ~/ 2];
                      return ListTile(
                        leading: TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: Text(data.vesselVerboseName),
                                    content: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Route id: ${data.routeId}',
                                          ),
                                          Text(
                                            'Country: ${data.countryOfOrigin}',
                                          ),
                                          Text(
                                            'Capacity: ${data.maxLoadCapacity.ceil()}',
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
                            data.vesselVerboseName.toString(),
                          ),
                        ),
                        title: Center(
                          child: Text(
                              "Is busy: ${data.routeId.toString() == 'null' ? 'No' : 'Yes'}"),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: credentials!['marine_worker_id'] == null
                              ? null
                              : () {
                                  BlocProvider.of<ShipDataCubit>(context)
                                      .removeShip(data.id);
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

  void _displaySnackbar(String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      content: Text(message),
    ));
  }
}
