import 'package:elementix/screens/history.dart';
import 'package:elementix/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class Sensor extends StatefulWidget {
  const Sensor({Key? key}) : super(key: key);

  @override
  State<Sensor> createState() => _SensorState();
}

class _SensorState extends State<Sensor> {
  Map sensorValues = {};

  // Getting firebase database instance
  DatabaseReference sensorCount = FirebaseDatabase.instance.ref('Sensors');

  // Function to get values from Sensors collection
  void getValues() {
    sensorCount.onValue.listen((event) {
      final data = event.snapshot.value;
      // log(data.toString());
      setState(() {
        sensorValues = data as Map;
      });
    });
  }

  // Snackbar. type (success | danger);
  _showSnackbar(String text, String type) {
    var snackBar = SnackBar(
      content: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: type == 'success' ? Colors.green[600] : Colors.red[600],
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Calling the getValue function initially
  @override
  void initState() {
    super.initState();
    getValues();
  }

  Future<void> _logoutUser() async {
    await FirebaseAuth.instance.signOut();
    _showSnackbar('User logged out successfully', 'success');
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meter Screen'),
        actions: [
          IconButton(
            onPressed: () {
              _logoutUser();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.blue[500],
              child: Center(
                child: Text(
                  'Gas Sensor: ${sensorValues['Sensor1']}',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.green[500],
              child: Center(
                child: Text(
                  'Smog Sensor: ${sensorValues['Sensor2']}',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(const History());
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.history),
      ),
    );
  }
}
