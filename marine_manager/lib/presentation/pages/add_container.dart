import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icon.dart';
import '../../data/entities/vessel.dart';
import '../../logic/container_data_cubit/container_data_cubit.dart';
import '../../logic/account_data_cubit/account_data_cubit.dart';
import '../../logic/app_cubit/app_cubit.dart';

class AddContainer extends StatefulWidget {
  const AddContainer({super.key});

  @override
  State<AddContainer> createState() => _AddContainerState();
}

class _AddContainerState extends State<AddContainer> {
  String? vesselId;
  String? dispPortId;
  String? destPortId;
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add container'),
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
                    'Add container',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FutureBuilder(
                    future: BlocProvider.of<ContainerDataCubit>(context)
                        .getVesselList(),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Wait for loading');
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        return DropdownButton<String>(
                          hint: const Text('Vessel'),
                          icon: LineIcon.ship(
                            color: Colors.blue,
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: 'null',
                              child: Text('No vessel'),
                            ),
                            ...List.generate(snapshot.data!.length, (index) {
                              return DropdownMenuItem(
                                value: snapshot.data![index].id.toString(),
                                child: Text(
                                    snapshot.data![index].vesselVerboseName),
                              );
                            }),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              vesselId = value;
                            });
                          },
                        );
                      }
                      return const Text('Waiting for data');
                    },
                  ),
                  Text(vesselId.toString()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FutureBuilder(
                    future: BlocProvider.of<ContainerDataCubit>(context)
                        .getPortList(),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Wait for loading');
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        return DropdownButton<String>(
                          hint: const Text('Dispatch port'),
                          icon: LineIcon.arrowCircleRight(
                            color: Colors.blue,
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: 'null',
                              child: Text('No dispatch?!'),
                            ),
                            ...List.generate(snapshot.data!.length, (index) {
                              return DropdownMenuItem(
                                value: snapshot.data![index].id.toString(),
                                child: Text(snapshot.data![index].portName),
                              );
                            }),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              dispPortId = value;
                            });
                          },
                        );
                      }
                      return const Text('Waiting for data');
                    },
                  ),
                  Text(dispPortId.toString()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FutureBuilder(
                    future: BlocProvider.of<ContainerDataCubit>(context)
                        .getPortList(),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Wait for loading');
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        return DropdownButton<String>(
                          hint: const Text('Destination port'),
                          icon: LineIcon.arrowCircleLeft(
                            color: Colors.blue,
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: 'null',
                              child: Text('No destination'),
                            ),
                            ...List.generate(snapshot.data!.length, (index) {
                              return DropdownMenuItem(
                                value: snapshot.data![index].id.toString(),
                                child: Text(snapshot.data![index].portName),
                              );
                            }),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              destPortId = value;
                            });
                          },
                        );
                      }
                      return const Text('Waiting for data');
                    },
                  ),
                  Text(destPortId.toString()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _codeController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: 'Container code',
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
                      onPressed: () {
                        if (_codeController.text.isEmpty ||
                            dispPortId == 'null' ||
                            dispPortId == destPortId) {
                          _displaySnackbar(
                              'Fill dispatch port and code (disp!=dest)!');
                          return;
                        }
                        BlocProvider.of<ContainerDataCubit>(context)
                            .createContainer(
                          dispPortId: dispPortId,
                          destPortId: destPortId,
                          vesselId: vesselId,
                          code: _codeController.text,
                        );
                        print('Vessel id: $vesselId');
                        Navigator.of(context).pop();
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
    _codeController.dispose();
    super.dispose();
  }
}
