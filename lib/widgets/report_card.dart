import 'dart:io';
import 'package:flutter/material.dart';
import '../models/report.dart';

class ReportCard extends StatelessWidget {
  final Report report;
  final VoidCallback? onTap;
  const ReportCard({super.key, required this.report, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLocalImage = report.imageUrl.startsWith('/');
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: isLocalImage
              ? Image.file(
                  File(report.imageUrl),
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  'assets/images/placeholder.png',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
        ),
        title: Text(report.title),
        subtitle: Text('${report.category} • ${report.location}'),
        onTap: onTap,
      ),
    );
  }
}
