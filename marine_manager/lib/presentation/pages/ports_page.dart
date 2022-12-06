import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marine_manager/logic/container_data_cubit/container_data_cubit.dart';

class PortsPage extends StatefulWidget {
  const PortsPage({super.key});

  @override
  State<PortsPage> createState() => _PortsPageState();
}

class _PortsPageState extends State<PortsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ports'),
      ),
      body: Column(
        children: [],
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
