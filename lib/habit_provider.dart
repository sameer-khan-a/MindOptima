import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HabitsProvider with ChangeNotifier {
  List<Map<String, String>> _habits = [];
  List<Map<String, String>> _completedHabits = [];
  List<Map<String, String>> _importantHabits = [];
  List<Map<String, String>> _habitsQuit = [];
  List<Map<String, String>> _completedHabitsQuit = [];
  List<Map<String, String>> _importantHabitsQuit = [];

  List<Map<String, String>> get habits => _habits;
  List<Map<String, String>> get completedHabits => _completedHabits;
  List<Map<String, String>> get importantHabits => _importantHabits;
  List<Map<String, String>> get habitsQuit => _habitsQuit;
  List<Map<String, String>> get completedHabitsQuit => _completedHabitsQuit;
  List<Map<String, String>> get importantHabitsQuit => _importantHabitsQuit;

  Future<void> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String>? savedHabits = prefs.getStringList('habits');
    final List<String>? savedCompletedHabits = prefs.getStringList('completedHabits');
    final List<String>? savedImportantHabits = prefs.getStringList('importantHabits');
    final List<String>? savedHabitsQuit = prefs.getStringList('habitsQuit');
    final List<String>? savedCompletedHabitsQuit = prefs.getStringList('completedHabitsQuit');
    final List<String>? savedImportantHabitsQuit = prefs.getStringList('importantHabitsQuit');

    if (savedHabits != null) {
      _habits = savedHabits.map((habit) {
        final parts = habit.split('|');
        return {
          'habit': parts[0],
          'description': parts[1],
        };
      }).toList();
    }

    if (savedCompletedHabits != null) {
      _completedHabits = savedCompletedHabits.map((habit) {
        final parts = habit.split('|');
        return {
          'habit': parts[0],
          'description': parts[1],
        };
      }).toList();
    }

    if (savedImportantHabits != null) {
      _importantHabits = savedImportantHabits.map((habit) {
        final parts = habit.split('|');
        return {
          'habit': parts[0],
          'description': parts[1],
        };
      }).toList();
    }

    if (savedHabitsQuit != null) {
      _habitsQuit = savedHabitsQuit.map((habit) {
        final parts = habit.split('|');
        return {
          'habit': parts[0],
          'description': parts[1],
        };
      }).toList();
    }

    if (savedCompletedHabitsQuit != null) {
      _completedHabitsQuit = savedCompletedHabitsQuit.map((habit) {
        final parts = habit.split('|');
        return {
          'habit': parts[0],
          'description': parts[1],
        };
      }).toList();
    }

    if (savedImportantHabitsQuit != null) {
      _importantHabitsQuit = savedImportantHabitsQuit.map((habit) {
        final parts = habit.split('|');
        return {
          'habit': parts[0],
          'description': parts[1],
        };
      }).toList();
    }

    notifyListeners();
  }

  Future<void> saveHabits() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> savedHabits = _habits.map((habit) {
      return '${habit['habit']}|${habit['description']}';
    }).toList();

    final List<String> savedCompletedHabits = _completedHabits.map((habit) {
      return '${habit['habit']}|${habit['description']}';
    }).toList();

    final List<String> savedImportantHabits = _importantHabits.map((habit) {
      return '${habit['habit']}|${habit['description']}';
    }).toList();

    final List<String> savedHabitsQuit = _habitsQuit.map((habit) {
      return '${habit['habit']}|${habit['description']}';
    }).toList();

    final List<String> savedCompletedHabitsQuit = _completedHabitsQuit.map((habit) {
      return '${habit['habit']}|${habit['description']}';
    }).toList();

    final List<String> savedImportantHabitsQuit = _importantHabitsQuit.map((habit) {
      return '${habit['habit']}|${habit['description']}';
    }).toList();

    await prefs.setStringList('habits', savedHabits);
    await prefs.setStringList('completedHabits', savedCompletedHabits);
    await prefs.setStringList('importantHabits', savedImportantHabits);
    await prefs.setStringList('habitsQuit', savedHabitsQuit);
    await prefs.setStringList('completedHabitsQuit', savedCompletedHabitsQuit);
    await prefs.setStringList('importantHabitsQuit', savedImportantHabitsQuit);
  }

  void addHabit(Map<String, String> habit) {
    _habits.add(habit);
    saveHabits();
    notifyListeners();
  }

  void completeHabit(int index) {
    _completedHabits.add(_habits.removeAt(index));
    saveHabits();
    notifyListeners();
  }

  void undoHabitCompletion(int index) {
    _habits.add(_completedHabits.removeAt(index));
    saveHabits();
    notifyListeners();
  }

  void removeHabit(int index) {
    _habits.removeAt(index);
    saveHabits();
    notifyListeners();
  }

  void markHabitAsImportant(int index) {
    _importantHabits.add(_habits.removeAt(index));
    saveHabits();
    notifyListeners();
  }

  void unmarkHabitAsImportant(int index) {
    _habits.add(_importantHabits.removeAt(index));
    saveHabits();
    notifyListeners();
  }

  void removeCompletedHabit(int index) {
    _completedHabits.removeAt(index);
    saveHabits();
    notifyListeners();
  }

  void removeImportantHabit(int index) {
    _importantHabits.removeAt(index);
    saveHabits();
    notifyListeners();
  }

  // Quit habits methods
  void addHabitQuit(Map<String, String> habit) {
    _habitsQuit.add(habit);
    saveHabits();
    notifyListeners();
  }

  void completeHabitQuit(int index) {
    _completedHabitsQuit.add(_habitsQuit.removeAt(index));
    saveHabits();
    notifyListeners();
  }

  void undoHabitCompletionQuit(int index) {
    _habitsQuit.add(_completedHabitsQuit.removeAt(index));
    saveHabits();
    notifyListeners();
  }

  void removeHabitQuit(int index) {
    _habitsQuit.removeAt(index);
    saveHabits();
    notifyListeners();
  }

  void markHabitAsImportantQuit(int index) {
    _importantHabitsQuit.add(_habitsQuit.removeAt(index));
    saveHabits();
    notifyListeners();
  }

  void unmarkHabitAsImportantQuit(int index) {
    _habitsQuit.add(_importantHabitsQuit.removeAt(index));
    saveHabits();
    notifyListeners();
  }

  void removeCompletedHabitQuit(int index) {
    _completedHabitsQuit.removeAt(index);
    saveHabits();
    notifyListeners();
  }

  void removeImportantHabitQuit(int index) {
    _importantHabitsQuit.removeAt(index);
    saveHabits();
    notifyListeners();
  }
}
