// ignore_for_file: prefer_const_declarations

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/medical_notes.dart';
import '../constants/Env.dart';

class TodosProvider extends ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos.where((todo) => todo.isDone == false).toList();
  List<Todo> get todosCompleted =>
      _todos.where((todo) => todo.isDone == true).toList();

  String _getUrl(String endpoint) {
    return '${Env.prefix}/$endpoint';
  }

  Future fetchTodos(String accountID) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final response = await http.get(
      Uri.parse(
        _getUrl('user/notes/get/$accountID'),
      ),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Todo> list = items.map<Todo>((json) => Todo.fromJson(json)).toList();
      _todos = list;
      notifyListeners();
    } else {
      throw Exception('Failed to load todos  ${jsonDecode(response.body)}');
    }
  }

  Future addTodo(Todo todo, String accountID) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.post(
      Uri.parse(_getUrl('user/notes/create/')),
      headers: headers,
      body: jsonEncode(todo.toJson()),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 201) {
      fetchTodos(accountID);
      notifyListeners();
    } else {
      throw Exception(
          'Failed to add todo. Server responded with status code ${response.statusCode} ${jsonDecode(response.body)}');
    }
  }

  Future updateTodo(Todo todo, String accountID) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final response = await http.put(
        Uri.parse(
          _getUrl('user/notes/update/${todo.noteNum}'),
        ),
        headers: headers,
        body: jsonEncode(todo.toJson()));

    if (response.statusCode == 204) {
      fetchTodos(accountID);
      notifyListeners();
    } else {
      throw Exception('Failed to update todo');
    }
  }

  Future toggleTodoStatus(Todo todo, String accountID) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode({
      'account': todo.account,
      'isDone': !todo.isDone,
    });
    final response = await http.put(
      Uri.parse(_getUrl('user/notes/done/${todo.noteNum}')),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 204) {
      todo.isDone = !todo.isDone;
      fetchTodos(todo.account);
    } else {
      throw Exception(
          'Failed to update todo status  ${jsonDecode(response.body)}');
    }
  }

  Future removeTodo(Todo todo, String accountID) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode({'account': todo.account});
    final response = await http.delete(
      Uri.parse(_getUrl('user/notes/delete/${todo.noteNum}')),
      headers: headers,
      body: body,
    );
    if (response.statusCode == 204) {
      fetchTodos(todo.account);
    } else {
      throw Exception('Failed to delete todo ${jsonDecode(response.body)}');
    }
  }
}
