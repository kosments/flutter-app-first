import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DogImageScreen(),
    );
  }
}

class DogImageScreen extends StatefulWidget {
  @override
  _DogImageScreenState createState() => _DogImageScreenState();
}

class _DogImageScreenState extends State<DogImageScreen> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    fetchDogImage();
  }

  Future<void> fetchDogImage() async {
    const apiUrl = 'https://dog.ceo/api/breeds/image/random';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          imageUrl = data['message'];
        });
      } else {
        throw Exception('Failed to load dog image');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Dog Image'),
      ),
      body: Center(
        child: imageUrl == null
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    imageUrl!,
                    height: 300,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: fetchDogImage,
                    child: Text('Load Another Image'),
                  ),
                ],
              ),
      ),
    );
  }
}
