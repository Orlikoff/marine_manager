import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/container_data_cubit/container_data_cubit.dart';

class ShipsPage extends StatefulWidget {
  const ShipsPage({super.key});

  @override
  State<ShipsPage> createState() => _ShipsPageState();
}

class _ShipsPageState extends State<ShipsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ships'),
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
