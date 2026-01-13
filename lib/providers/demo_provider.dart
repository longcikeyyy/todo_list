import 'package:flutter/material.dart';

class DemoProvider extends ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;

  int _age = 20;
  int get age => _age;

  void incrementCounter() {
    _counter++;
    debugPrint('Counter value: $_counter');
    notifyListeners();
  }

  void decrementCounter() {
    _counter--;
    debugPrint('Counter value: $_counter');
    notifyListeners();
  }

  void incrementAge() {
    _age++;
    debugPrint('Age value: $_age');
    notifyListeners();
  }

  void decrementAge() {
    _age--;
    debugPrint('Age value: $_age');
    notifyListeners();
  }
}
