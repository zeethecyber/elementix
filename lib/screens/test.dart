import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List users = ['zeeshan', 'faizan', 'muneeb', 'sohaib'];

    return Scaffold(
      body: Column(
        children: users.map((e) {
          return Container();
        }).toList(),
      ),
    );
  }
}
