import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/entities/route.dart';
import '../../data/entities/vessel.dart';
import '../../logic/route_data_cubit/route_data_cubit.dart';
import '../../logic/ship_data_cubit/ship_data_cubit.dart';
import 'add_route.dart';
import 'add_ship.dart';
import '../../credentials.dart';
import '../../data/entities/container.dart';
import '../../logic/container_data_cubit/container_data_cubit.dart';

class RoutesPage extends StatefulWidget {
  const RoutesPage({super.key});

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Routes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: credentials!['marine_worker_id'] == null
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AddRoute(),
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
                  await BlocProvider.of<RouteDataCubit>(context).loadRoutes();
                },
                child: const Text('Fetch data'),
              ),
            ],
          ),
          BlocBuilder<RouteDataCubit, RouteDataState>(
            builder: (context, state) {
              if (state is RouteDataLoading) {
                return const CircularProgressIndicator();
              } else if (state is RouteDataChanged) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.data.length * 2,
                    itemBuilder: (context, index) {
                      if (index % 2 == 1) return const Divider();
                      final RouteData data = state.data[index ~/ 2];
                      return ListTile(
                        leading: TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: Text(data.routeVesselCode),
                                    content: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Shipment company: ${data.shipmentCompany}',
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
                            data.routeVesselCode.toString(),
                          ),
                        ),
                        title: Center(
                          child: Text("Owned by: ${data.shipmentCompany}"),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: credentials!['marine_worker_id'] == null
                              ? null
                              : () {
                                  BlocProvider.of<RouteDataCubit>(context)
                                      .removeRoute(data.id);
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
