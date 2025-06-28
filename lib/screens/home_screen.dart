import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/report_card.dart';
import 'profile_screen.dart';
import 'add_report_screen.dart';
import 'report_detail_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import 'package:provider/provider.dart';
import '../providers/report_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String searchQuery = "";
  String selectedCategory = "Semua";
  final List<String> categories = ["Semua", "Elektronik", "Dompet", "Kunci", "Buku", "Lainnya"];

  @override
  Widget build(BuildContext context) {
    // Filter laporan berdasarkan kategori dan pencarian
    final reports = context.watch<ReportProvider>().reports.where((report) {
      final matchesCategory =
          selectedCategory == "Semua" || report.category == selectedCategory;
      final matchesSearch =
          searchQuery.isEmpty ||
          report.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          report.description.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    final List<Widget> _pages = [
      SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width > 500 ? MediaQuery.of(context).size.width * 0.15 : 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: "Cari barang hilang ...",
                  hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFF875AA)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                style: GoogleFonts.poppins(),
                onChanged: (value) => setState(() => searchQuery = value),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (ctx, i) {
                    final isSelected = categories[i] == selectedCategory;
                    return ChoiceChip(
                      label: Text(categories[i],
                        style: GoogleFonts.poppins(
                          color: isSelected ? Colors.white : const Color(0xFFF875AA),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFFF875AA),
                      backgroundColor: Colors.white,
                      onSelected: (_) => setState(() => selectedCategory = categories[i]),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      side: BorderSide(color: isSelected ? const Color(0xFFF875AA) : Colors.grey.shade200),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: reports.isEmpty
                    ? Center(
                        child: Text(
                          "Belum ada laporan.",
                          style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: reports.length,
                        itemBuilder: (context, index) {
                          final report = reports[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ReportDetailScreen(report: report),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                color: Colors.white,
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
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          report.title,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
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
                                              report.isFound ? Icons.check_circle : Icons.search,
                                              color: report.isFound ? Colors.green : Colors.orange,
                                              size: 15,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              report.isFound ? "Sudah ditemukan" : "Masih dicari",
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: report.isFound ? Colors.green : Colors.orange,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Color(0xFFF875AA)),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add, color: Colors.white, size: 20),
                  label: Text("Tambah Laporan",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AddReportScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF875AA),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      const HistoryScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          _currentIndex == 0 ? "Lost Mate"
            : _currentIndex == 1 ? "Riwayat"
            : "Profil",
          style: GoogleFonts.poppins(
            color: const Color(0xFFF875AA),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          if (_currentIndex == 0)
            IconButton(
              icon: const Icon(Icons.settings, color: Color(0xFFF875AA)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
              },
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() => _currentIndex = value);
        },
        selectedItemColor: const Color(0xFFF875AA),
        unselectedItemColor: Colors.grey[400],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Riwayat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}
