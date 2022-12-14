import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marine_manager/data/entities/port.dart';
import 'package:marine_manager/logic/route_data_cubit/route_data_cubit.dart';

class AddRoute extends StatefulWidget {
  const AddRoute({super.key});

  @override
  State<AddRoute> createState() => _AddRouteState();
}

class _AddRouteState extends State<AddRoute> {
  final TextEditingController _vesselController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  late List<PortData> snapshotData;
  final List<PortData> portsAdded = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add route'),
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
                    'Add route',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: BlocProvider.of<RouteDataCubit>(context).loadPorts(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Loading data');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    snapshotData = snapshot.data;
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: snapshotData.length,
                              itemBuilder: ((context, index) {
                                return ListTile(
                                  title: Text(snapshotData[index].portName),
                                  trailing: portsAdded
                                          .contains(snapshotData[index])
                                      ? IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () async {
                                            setState(() {
                                              portsAdded
                                                  .remove(snapshotData[index]);
                                            });
                                          },
                                        )
                                      : IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () async {
                                            setState(() {
                                              portsAdded
                                                  .add(snapshotData[index]);
                                            });
                                          }),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const Text('Loading data');
                },
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
                    hintText: 'Shipment company',
                    fillColor: Colors.white70),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _vesselController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: 'Route code',
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
                            _vesselController.text.isEmpty) {
                          _displaySnackbar('Fill fields');
                          return;
                        }

                        await BlocProvider.of<RouteDataCubit>(context)
                            .createRoute(
                          shipmentCompany: _companyController.text,
                          routeVesselCode: _vesselController.text,
                          portsLinked: portsAdded,
                        );
                        if (mounted) Navigator.of(context).pop();
                      },
                      child: const Text('Create'),
                    ),
                  ),
                ],
              ),
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
    _vesselController.dispose();
    super.dispose();
  }
}
