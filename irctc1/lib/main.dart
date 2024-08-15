import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(PNRStatusCheckerApp());
}

class PNRStatusCheckerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PNRStatusScreen(),
    );
  }
}

class PNRStatusScreen extends StatefulWidget {
  @override
  _PNRStatusScreenState createState() => _PNRStatusScreenState();
}

class _PNRStatusScreenState extends State<PNRStatusScreen> {
  final _pnrController = TextEditingController();
  String _pnrStatus = '';

  Future<void> _fetchPNRDetails(String pnr) async {
    final url = Uri.parse('http://your-server-url.com/fetch-pnr-details');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'pnr': pnr}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _pnrStatus = data.toString();
        });
      } else {
        setState(() {
          _pnrStatus = 'Failed to fetch PNR details';
        });
      }
    } catch (error) {
      setState(() {
        _pnrStatus = 'Error: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PNR Status Checker'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _pnrController,
                decoration: InputDecoration(
                  labelText: 'Enter PNR Number',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _fetchPNRDetails(_pnrController.text);
                },
                child: Text('Check PNR Status'),
              ),
              SizedBox(height: 20),
              Text(_pnrStatus),
            ],
          ),
        ),
      ),
    );
  }
}


