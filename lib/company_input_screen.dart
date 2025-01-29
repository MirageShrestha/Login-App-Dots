import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';
import 'globals.dart';

class CompanyInputScreen extends StatefulWidget {
  @override
  _CompanyInputScreenState createState() => _CompanyInputScreenState();
}

class _CompanyInputScreenState extends State<CompanyInputScreen> {
  final TextEditingController _companyController = TextEditingController();
  bool _isLoading = false;

  void _next() async {
    if (_companyController.text.isEmpty) {
      _showErrorSnackbar('Please enter a company name');
      return;
    }

    final url = Uri.parse('http://45.115.217.134:82/api/method/hrmapping');
    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"company": _companyController.text}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final company = data['Data']['company'];
        final imageUrl = data['Data']['imageurl'];
        apiIp = data['Data']['ip'];

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen(company: company, imageUrl: imageUrl, ip: apiIp!)),
        );
      } else {
        _showErrorSnackbar('Invalid Company Name.');
      }
    } catch (e) {
      _showErrorSnackbar('An error occurred: $e');
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.blueGrey[700]), // Change text color
        ),
        backgroundColor: Colors.blueGrey[100], // Change background color
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey[50]!, Colors.blueGrey[50]!], // Gradient background
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: _isLoading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white, // White background for the input container
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[800],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Please enter your company name below:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey[700],
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _companyController,
                          decoration: InputDecoration(
                            labelText: 'Company Name',
                            labelStyle: TextStyle(color: Colors.blueGrey[700]),
                            prefixIcon: Icon(Icons.business, color: Colors.blueGrey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.blueGrey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _next,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5, // Add shadow to the button
                          ),
                          child: Text('Next', style: TextStyle(fontSize: 18, color: Colors.blueGrey[800])),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}