import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_auth/firebase_auth.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  // State to store alarms list from firebase
  List alarmsList = [];

  User? user = FirebaseAuth.instance.currentUser;

  // Getting firebase database instance
  DatabaseReference alarmsData = FirebaseDatabase.instance.ref('alarms');

  // Function to get values from Sensors collection
  void getValues() {
    alarmsData.onValue.listen((event) {
      final data = event.snapshot.value as Map;
      // log(data.toString());
      final dataNew = data[user!.uid];
      if (dataNew != null) {
        setState(() {
          alarmsList = dataNew as List;
        });
      }
    });
  }

  // Calling the getValue function initially
  @override
  void initState() {
    super.initState();
    getValues();
    initializeDateFormatting();
  }

  // Table Header Builder
  _buildTableHeader(List<String> headers) {
    return TableRow(
      children: headers.map((item) {
        return TableCell(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              item,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Table Row Builder
  TableRow _buildTableRows(List<String> list) {
    return TableRow(
      children: list.map((item) {
        return TableCell(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              item,
            ),
          ),
        );
      }).toList(),
    );
  }

  // Format DateString to Date
  _getFormattedDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat.yMd().format(dateTime);

    return formattedDate;
  }

  // Format DateString to Time
  _getFormattedTime(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedTime = DateFormat.Hms().format(dateTime);

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    int tableSrCount = 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm History'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Alarm History',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            alarmsList.isNotEmpty
                ? Table(
                    border: TableBorder.all(),
                    columnWidths: const <int, TableColumnWidth>{
                      0: IntrinsicColumnWidth(),
                      1: FlexColumnWidth(),
                      2: FlexColumnWidth(),
                      3: FlexColumnWidth(),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      _buildTableHeader(['Sr', 'Sensor', 'Date', 'Time']),
                      ...alarmsList.map((item) {
                        tableSrCount++;
                        return _buildTableRows([
                          '$tableSrCount',
                          '${item['sensor']}',
                          _getFormattedDate(item['datetime']),
                          _getFormattedTime(item['datetime']),
                        ]);
                      }).toList()
                    ],
                  )
                : const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No record found for this user'),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
