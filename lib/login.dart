import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_page.dart'; 
import 'globals.dart'; 

class LoginScreen extends StatefulWidget {
  final String company;
  final String imageUrl; 
  final String ip; 

  LoginScreen({required this.company, required this.imageUrl, required this.ip});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false; // To show loading state

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter both username and password';
      });
      return;
    }

    final url = Uri.parse('${widget.ip}/api/method/frappe.val.api.login'); // Use the IP passed from CompanyInputScreen
    setState(() {
      _isLoading = true; // Start loading
      _errorMessage = null; // Clear previous error message
    });

    try {
      final response = await http.post(
        url,
        body: {
          'usr': _usernameController.text,
          'pwd': _passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['message'] == 'Logged In') {
          // Extract the authentication token from the response
          authToken = data['auth']['token']; // Store the token in the global variable

          // Navigate to the next page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          setState(() {
            _errorMessage = 'Invalid username or password';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Login Failed. Please check your credentials.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again later.';
      });
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[50], // App bar color
        elevation: 0, // No shadow for a flat look
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey[50]!, Colors.blueGrey[50]!], // Gradient background
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Image.network(
                    widget.imageUrl, // Use the image URL passed from CompanyInputScreen
                    height: 100, // Set a height for the image
                    fit: BoxFit.cover, // Adjust the image to cover the space
                  ),
                ),
                SizedBox(height: 20), // Space between the image and the container
                Container(
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
                        'Login to ${widget.company}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(color: Colors.blueGrey[700]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueGrey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
                          ),
                          errorText: _errorMessage,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.blueGrey[700]),
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
                        onPressed: _isLoading ? null : _login, // Disable button while loading
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5, // Add shadow to the button
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator() // Show loading indicator
                            : Text('Login', style: TextStyle(fontSize: 18, color: Colors.blueGrey[800])),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}