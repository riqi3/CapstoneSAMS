// ignore_for_file: prefer_const_declarations

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/MedicalNotesModel.dart';
import '../constants/Env.dart';

class TodosProvider extends ChangeNotifier {
  Todo? _todo;
  bool? get isDeleted => _todo?.isDeleted;
  List<Todo> _todos = [];
  bool _isLoading = false;

  List<Todo> get todos => _todos.where((todo) => todo.isDone == false).toList();
  List<Todo> get todosCompleted =>
      _todos.where((todo) => todo.isDone == true).toList();
  bool get isLoading => _isLoading;
  String _getUrl(String endpoint) {
    return '${Env.prefix}/$endpoint';
  }

  Future fetchTodos(int accountID, String token) async {
    _isLoading = true;

    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.get(
        Uri.parse(
          _getUrl('user/notes/get/$accountID'),
        ),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final items = json.decode(response.body).cast<Map<String, dynamic>>();
        List<Todo> list =
            items.map<Todo>((json) => Todo.fromJson(json)).toList();
        _todos = list;
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
      }
    } on Exception catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future addTodo(Todo todo, int accountID, String token) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.post(
        Uri.parse(_getUrl('user/notes/create/')),
        headers: headers,
        body: jsonEncode(todo.toJson()),
      );
      if (response.statusCode == 201) {
        fetchTodos(accountID, token);
        notifyListeners();
      } else {
        print(
            'Failed to add todo. Server responded with status code ${response.statusCode} ${jsonDecode(response.body)}');
      }
    } on Exception catch (e) {
      print('Failed to add todo. Error: $e');
    }
  }

  Future updateTodo(Todo todo, int accountID, String token) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.put(
          Uri.parse(
            _getUrl('user/notes/update/${todo.noteNum}'),
          ),
          headers: headers,
          body: jsonEncode(todo.toJson()));

      if (response.statusCode == 204) {
        fetchTodos(accountID, token);
        notifyListeners();
      } else {
        print(
            'Failed to update todo. Server responded with status code ${response.statusCode} ${jsonDecode(response.body)}');
      }
    } on Exception catch (e) {
      print('Failed to update todo. Error: $e');
    }
  }

  Future toggleTodoStatus(Todo todo, int accountID, String token) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      'account': todo.account,
      'isDone': !todo.isDone,
    });
    try {
      final response = await http.put(
        Uri.parse(_getUrl('user/notes/done/${todo.noteNum}')),
        headers: headers,
        body: body,
      );
      // await Future.delayed(Duration(milliseconds: 3000));

      if (response.statusCode == 204) {
        todo.isDone = !todo.isDone;
        fetchTodos(todo.account, token);
      } else {
        print('Failed to toggle todo status  ${jsonDecode(response.body)}');
      }
    } on Exception catch (e) {
      print('Failed to toggle todo. Error: $e');
    }
  }

  Future removeTodo(Todo todo, int accountID, String token) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({'account': todo.account});

    try {
      final response = await http.post(
        Uri.parse(_getUrl('user/notes/delete/${todo.noteNum}')),
        headers: headers,
        body: body,
      );
      // await Future.delayed(Duration(milliseconds: 3000));
      if (response.statusCode == 204) {
        fetchTodos(todo.account, token);
        notifyListeners();
      } else {
        print('Failed to delete todo ${jsonDecode(response.body)}');
      }
    } on Exception catch (e) {
      print('Failed to delete todo. Error: $e');
    }
  }

  void setEmpty() {
    _todos = [];
    notifyListeners();
  }
}
