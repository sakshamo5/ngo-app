import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ngo.dart';
import 'user.dart';

class DonationRecord {
  final String ngoId;
  final String ngoName;
  final double amount;
  final DateTime date;
  final String paymentMethod;

  DonationRecord({
    required this.ngoId,
    required this.ngoName,
    required this.amount,
    required this.date,
    required this.paymentMethod,
  });

  Map<String, dynamic> toMap() => {
        'ngoId': ngoId,
        'ngoName': ngoName,
        'amount': amount,
        'date': date.toIso8601String(),
        'paymentMethod': paymentMethod,
      };

  factory DonationRecord.fromMap(Map<String, dynamic> map) => DonationRecord(
        ngoId: map['ngoId'] as String,
        ngoName: map['ngoName'] as String,
        amount: (map['amount'] as num).toDouble(),
        date: DateTime.parse(map['date'] as String),
        paymentMethod: map['paymentMethod'] as String,
      );
}

class AppState extends ChangeNotifier {
  // Singleton
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  AppUser? _user;
  final List<Ngo> _ngos = List.from(Ngo.dummyNgos);
  List<AppUser> _registeredUsers = [];
  List<DonationRecord> _donationHistory = [];

  AppUser? get user => _user;
  List<Ngo> get ngos => _ngos;
  bool get isLoggedIn => _user != null;
  List<DonationRecord> get donationHistory =>
      List.unmodifiable(_donationHistory);

  List<Ngo> ngosByCategory(String category) =>
      _ngos.where((n) => n.category == category).toList();

  // ─── Initialization: load persisted data ───
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    // Load registered users
    final usersJson = prefs.getString('registered_users');
    if (usersJson != null) {
      final List<dynamic> list = jsonDecode(usersJson);
      _registeredUsers = list.map((m) => AppUser.fromMap(m)).toList();
    }

    // Load NGO raised amounts
    final ngoJson = prefs.getString('ngo_raised');
    if (ngoJson != null) {
      final Map<String, dynamic> raised = jsonDecode(ngoJson);
      for (final ngo in _ngos) {
        if (raised.containsKey(ngo.id)) {
          ngo.raisedAmount = (raised[ngo.id] as num).toDouble();
        }
      }
    }

    // Load current session
    final sessionEmail = prefs.getString('session_email');
    if (sessionEmail != null) {
      try {
        _user = _registeredUsers.firstWhere((u) => u.email == sessionEmail);
        // Load this user's donation history
        _donationHistory = _loadHistoryForEmail(prefs, sessionEmail);
      } catch (_) {
        _user = null;
      }
    }
  }

  /// Reads donation history for a specific user email from prefs.
  List<DonationRecord> _loadHistoryForEmail(
      SharedPreferences prefs, String email) {
    final key = 'donation_history_$email';
    final historyJson = prefs.getString(key);
    if (historyJson == null) return [];
    final List<dynamic> list = jsonDecode(historyJson);
    return list.map((m) => DonationRecord.fromMap(m)).toList();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();

    // Save registered users (includes balances)
    final usersJson =
        jsonEncode(_registeredUsers.map((u) => u.toMap()).toList());
    await prefs.setString('registered_users', usersJson);

    // Save NGO raised amounts
    final raised = <String, double>{};
    for (final ngo in _ngos) {
      raised[ngo.id] = ngo.raisedAmount;
    }
    await prefs.setString('ngo_raised', jsonEncode(raised));

    // Save donation history (per user)
    if (_user != null) {
      final historyJson =
          jsonEncode(_donationHistory.map((d) => d.toMap()).toList());
      await prefs.setString('donation_history_${_user!.email}', historyJson);
    }

    // Save current session
    if (_user != null) {
      await prefs.setString('session_email', _user!.email);
    } else {
      await prefs.remove('session_email');
    }
  }

  // ─── Auth ───
  /// Returns null on success, or an error message string.
  String? signup(String name, String email, String password) {
    email = email.trim().toLowerCase();
    if (_registeredUsers.any((u) => u.email == email)) {
      return 'An account with this email already exists';
    }
    final newUser = AppUser(
      name: name.trim(),
      email: email,
      password: password,
      balance: 5000.0,
    );
    _registeredUsers.add(newUser);
    _user = newUser;
    notifyListeners();
    _save();
    return null; // success
  }

  /// Returns null on success, or an error message string.
  Future<String?> login(String email, String password) async {
    email = email.trim().toLowerCase();
    try {
      final found = _registeredUsers.firstWhere(
        (u) => u.email == email && u.password == password,
      );
      _user = found;
      // Load this user's donation history on every login
      final prefs = await SharedPreferences.getInstance();
      _donationHistory = _loadHistoryForEmail(prefs, found.email);
      notifyListeners();
      _save();
      return null; // success
    } catch (_) {
      return 'Invalid email or password';
    }
  }

  void logout() {
    // Don't wipe history from prefs — just clear from memory
    _user = null;
    _donationHistory = [];
    notifyListeners();
    _save();
  }

  // ─── Donation ───
  bool donate(String ngoId, double amount, {String paymentMethod = 'UPI'}) {
    if (_user == null || _user!.balance < amount || amount <= 0) return false;
    final ngo = _ngos.firstWhere((n) => n.id == ngoId);
    _user!.balance -= amount;
    ngo.raisedAmount += amount;
    _donationHistory.insert(
      0,
      DonationRecord(
        ngoId: ngoId,
        ngoName: ngo.name,
        amount: amount,
        date: DateTime.now(),
        paymentMethod: paymentMethod,
      ),
    );
    notifyListeners();
    _save();
    return true;
  }

  // ─── Top Up ───
  Future<void> topUp(double amount) async {
    if (_user == null || amount <= 0) return;
    await Future.delayed(const Duration(seconds: 2)); // simulate delay
    _user!.balance += amount;
    notifyListeners();
    _save();
  }
}
