// ignore_for_file: prefer_const_declarations

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/medical_notes.dart';

class TodosProvider extends ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos.where((todo) => todo.isDone == false).toList();
  List<Todo> get todosCompleted =>
      _todos.where((todo) => todo.isDone == true).toList();

  String _getUrl(String endpoint) {
    final baseUrl = 'http://10.0.2.2:8000';
    return '$baseUrl/$endpoint';
  }

  Future fetchTodos(String accountID) async {
    final response = await http.get(Uri.parse(_getUrl('notes/get/$accountID')));

    if (response.statusCode == 200) {
      List<Todo> list = parseTodos(response.body);
      _todos = list;
      notifyListeners();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  List<Todo> parseTodos(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Todo>((json) => Todo.fromJson(json)).toList();
  }

  Future addTodo(Todo todo, String accountID) async {
    final response = await http.post(
      Uri.parse(_getUrl('notes/create/')),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': todo.title,
        'content': todo.content,
        'iscomplete': todo.isDone.toString(),
        'accountID': accountID,
      }),
    );
    print('POST request to ${_getUrl('notes/create/')}');
    print('Headers: ${jsonEncode(<String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        })}');
    print('Body: ${jsonEncode(<String, dynamic>{
          'title': todo.title,
          'content': todo.content,
          'iscomplete': todo.isDone,
          'account': accountID,
        })}');
    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 201) {
      fetchTodos(accountID);
    } else {
      throw Exception(
          'Failed to add todo. Server responded with status code ${response.statusCode}');
    }
  }

  Future updateTodo(Todo todo, String accountID) async {
    final response = await http.put(
      Uri.parse(_getUrl('notes/update/${todo.noteNum}')),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': todo.title,
        'content': todo.content,
        'iscomplete': todo.isDone.toString(),
      }),
    );

    if (response.statusCode == 204) {
      fetchTodos(accountID);
    } else {
      throw Exception('Failed to update todo');
    }
  }

  Future toggleTodoStatus(Todo todo, String accountID) async {
    final response = await http.put(
      Uri.parse(_getUrl('notes/update/${todo.noteNum}')),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'isDone': (!todo.isDone).toString(),
      }),
    );

    if (response.statusCode == 204) {
      todo.isDone = !todo.isDone;
      fetchTodos(accountID);
    } else {
      throw Exception('Failed to update todo status');
    }
  }

  Future removeTodo(Todo todo, String accountID) async {
    final response = await http.delete(
      Uri.parse(_getUrl('notes/delete/int:noteNum')),
    );

    if (response.statusCode == 204) {
      fetchTodos(accountID);
    } else {
      throw Exception('Failed to delete todo');
    }
  }
}
