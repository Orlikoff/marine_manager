import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icon.dart';
import '../../data/entities/vessel.dart';
import '../../logic/container_data_cubit/container_data_cubit.dart';
import '../../logic/account_data_cubit/account_data_cubit.dart';
import '../../logic/app_cubit/app_cubit.dart';
import '../../logic/ship_data_cubit/ship_data_cubit.dart';

class AddShip extends StatefulWidget {
  const AddShip({super.key});

  @override
  State<AddShip> createState() => _AddShipState();
}

class _AddShipState extends State<AddShip> {
  String? routeId;
  final TextEditingController _vesselController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _loadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add ship'),
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
                    'Add ship',
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
                    future: BlocProvider.of<ShipDataCubit>(context).loadRoute(),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Wait for loading');
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        return DropdownButton<String>(
                          hint: const Text('Route'),
                          icon: LineIcon.route(
                            color: Colors.blue,
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: 'null',
                              child: Text('No route'),
                            ),
                            ...List.generate(snapshot.data!.length, (index) {
                              return DropdownMenuItem(
                                value: snapshot.data![index].id.toString(),
                                child:
                                    Text(snapshot.data![index].routeVesselCode),
                              );
                            }),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              routeId = value;
                            });
                          },
                        );
                      }
                      return const Text('Waiting for data');
                    },
                  ),
                  Text(routeId.toString()),
                ],
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
                    hintText: 'Vessel name',
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
              child: TextField(
                controller: _loadController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: 'Load capacity',
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
                        if (_loadController.text.isEmpty ||
                            _countryController.text.isEmpty ||
                            _vesselController.text.isEmpty) {
                          _displaySnackbar('Fill fields');
                          return;
                        }
                        try {
                          double.parse(_loadController.text);
                        } catch (_) {
                          _displaySnackbar('Load capacity must be double');
                          return;
                        }
                        BlocProvider.of<ShipDataCubit>(context).createShip(
                          routeId: routeId == 'null' ? null : routeId,
                          vesselVerboseName: _vesselController.text,
                          countryOfOrigin: _countryController.text,
                          maxLoadCapacity: _loadController.text,
                        );
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
    _countryController.dispose();
    _vesselController.dispose();
    _loadController.dispose();
    super.dispose();
  }
}
