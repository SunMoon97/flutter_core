import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_core/home.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_core/splash.dart';
// import 'package:firebase_core/firebase_core.dart';


void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  
  runApp(MyApp());
}

class Quote {
  final String text;
  final String author;

  Quote({required this.text, required this.author});
}

class Task {
  final String title;
  final String description;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  Task copyWith({
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Task(
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class AppState with ChangeNotifier {
  String quoteOfTheDay = 'Loading...';
  List<Task> tasks = [];

  Future<void> fetchQuoteOfTheDay() async {
    try {
      final response =
          await http.get(Uri.parse('https://api.quotable.io/random'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        quoteOfTheDay = '${data['content']} - ${data['author']}';
        notifyListeners();
      }
    } catch (error) {
      print('Error fetching quote: $error');
    }
  }

  void addTask(Task task) {
    tasks.add(task);
    notifyListeners();
  }

  void editTask(int index, Task task) {
    tasks[index] = task;
    notifyListeners();
  }

  void deleteTask(int index) {
    tasks.removeAt(index);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (_) => AppState()..fetchQuoteOfTheDay(),
      child: MaterialApp(
        title: 'Quote and Daily Planner App',
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => SplashScreen(),
          '/home': (context) => HomeScreen(),
          
        },
      ),
    );
  }
}
