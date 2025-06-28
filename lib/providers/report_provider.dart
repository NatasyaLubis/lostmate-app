import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/report.dart';

class ReportProvider extends ChangeNotifier {
  final List<Report> _reports = [];

  List<Report> get reports => List.unmodifiable(_reports);

  /// Load laporan dari SharedPreferences
  Future<void> loadReports() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('reports') ?? '[]';
    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      _reports.clear();
      _reports.addAll(jsonList.map((e) => Report.fromJson(e)).toList());
    } catch (e) {
      // Jika gagal decode, clear list dan mungkin log error
      _reports.clear();
    }
    notifyListeners();
  }

  /// Save laporan ke SharedPreferences
  Future<void> saveReports() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(_reports.map((e) => e.toJson()).toList());
    await prefs.setString('reports', jsonString);
  }

  /// Tambah laporan baru
  Future<void> addReport(Report report) async {
    _reports.add(report);
    await saveReports();
    notifyListeners();
  }

  /// Update laporan existing berdasarkan id
  Future<void> updateReport(Report updated) async {
    final idx = _reports.indexWhere((r) => r.id == updated.id);
    if (idx != -1) {
      _reports[idx] = updated;
      await saveReports();
      notifyListeners();
    }
  }

  /// Hapus laporan berdasarkan id
  Future<void> removeReport(String id) async {
    _reports.removeWhere((report) => report.id == id);
    await saveReports();
    notifyListeners();
  }
}
