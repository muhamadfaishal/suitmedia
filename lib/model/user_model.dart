import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserModel with ChangeNotifier {
  String _name = '';
  String _selectedUsername = '';
  List<User> _users = [];
  bool _hasMore = true;
  int _currentPage = 1;
  bool _isLoading = false;

  String get name => _name;
  String get selectedUsername => _selectedUsername;
  List<User> get users => _users;
  bool get hasMore => _hasMore;
  bool get isLoading => _isLoading;

  void setName(String newName) {
    _name = newName;
    notifyListeners();
  }

  void setSelectedUsername(String newUsername) {
    _selectedUsername = newUsername;
    notifyListeners();
  }

  Future<void> fetchUsers({bool isRefresh = false}) async {
    if (_isLoading) return;
    if (isRefresh) {
      _currentPage = 1;
      _users = [];
      _hasMore = true;
    }

    _isLoading = true;
    notifyListeners();

    final response = await http.get(
      Uri.parse('https://reqres.in/api/users?page=$_currentPage&per_page=10'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<User> fetchedUsers =
          (data['data'] as List).map((user) => User.fromJson(user)).toList();

      _users.addAll(fetchedUsers);
      _hasMore = _currentPage < data['total_pages'];
      _currentPage++;

      _isLoading = false;
      notifyListeners();
    } else {
      throw Exception('Failed to load users');
    }
  }
}

class User {
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  User({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar'],
    );
  }
}
