import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/report_provider.dart';
import '../models/report.dart';
import 'report_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;
    // Filter laporan hanya milik user yang login
    final reports = Provider.of<ReportProvider>(context).reports
        .where((r) => r.email == user?.email)
        .toList();

    // Pisah berdasarkan status ditemukan atau belum
    final belumDitemukan = reports.where((r) => !r.isFound).toList();
    final sudahDitemukan = reports.where((r) => r.isFound).toList();

    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TabBar tanpa judul, warna sesuai tema
          const TabBar(
            labelColor: Color(0xFFF875AA),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFFF875AA),
            tabs: [
              Tab(text: "Belum Ditemukan"),
              Tab(text: "Sudah Ditemukan"),
            ],
          ),
          // Expanded untuk isi TabBarView
          Expanded(
            child: TabBarView(
              children: [
                _buildList(belumDitemukan, context, false),
                _buildList(sudahDitemukan, context, true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildList(List<Report> list, BuildContext context, bool found) {
    if (list.isEmpty) {
      return Center(
        child: Text(
          found ? "Belum ada laporan ditemukan." : "Belum ada laporan.",
          style: GoogleFonts.poppins(color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: list.length,
      itemBuilder: (context, i) {
        final report = list[i];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          color: Colors.white, // Semua card putih tanpa abu-abu
          child: ListTile(
            leading: report.imageUrl.startsWith('/')
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(report.imageUrl),
                      width: 46,
                      height: 46,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    'assets/images/placeholder.png',
                    width: 46,
                    height: 46,
                    fit: BoxFit.cover,
                  ),
            title: Text(
              report.title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.category,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  "${report.date.day.toString().padLeft(2, '0')}-${report.date.month.toString().padLeft(2, '0')}-${report.date.year}",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    children: [
                      Icon(
                        found ? Icons.check_circle : Icons.search,
                        color: found ? Colors.green : Colors.orange,
                        size: 15,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        found ? "Sudah ditemukan" : "Masih dicari",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: found ? Colors.green : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Color(0xFFF875AA)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ReportDetailScreen(report: report)),
              );
            },
          ),
        );
      },
    );
  }
}
