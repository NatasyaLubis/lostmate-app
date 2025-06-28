import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/report.dart';
import '../providers/auth_provider.dart';
import '../providers/report_provider.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'edit_report_screen.dart';

class ReportDetailScreen extends StatefulWidget {
  final Report report;
  const ReportDetailScreen({super.key, required this.report});

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  late Report report;

  @override
  void initState() {
    super.initState();
    report = widget.report;
  }

  LatLng? parseLatLng(String loc) {
    try {
      final parts = loc.split(',');
      final lat = double.parse(parts[0].trim());
      final lng = double.parse(parts[1].trim());
      return LatLng(lat, lng);
    } catch (e) {
      return null;
    }
  }

  Future<void> _deleteReport() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Hapus laporan ini?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(ctx, false),
          ),
          TextButton(
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await Provider.of<ReportProvider>(context, listen: false).removeReport(report.id);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Laporan berhasil dihapus!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;
    final isOwner = user?.email == report.email;
    final isFound = report.isFound;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F0),
      appBar: AppBar(
        title: Text(
          "Detail Laporan",
          style: GoogleFonts.poppins(
            color: const Color(0xFFF875AA),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFFF875AA)),
        elevation: 0.5,
        actions: [
          if (isOwner)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Color(0xFFF875AA)),
              onSelected: (value) async {
                if (value == 'edit') {
                  final updated = await Navigator.push<Report?>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditReportScreen(report: report),
                    ),
                  );
                  if (updated != null) {
                    await Provider.of<ReportProvider>(context, listen: false).updateReport(updated);
                    setState(() {
                      report = updated;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Laporan berhasil diupdate!")),
                    );
                  }
                } else if (value == 'delete') {
                  await _deleteReport();
                } else if (value == 'found' && !isFound) {
                  final updated = report.copyWith(isFound: true);
                  await Provider.of<ReportProvider>(context, listen: false).updateReport(updated);
                  setState(() {
                    report = updated;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Laporan ditandai sudah ditemukan!")),
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Hapus')),
                if (!isFound)
                  const PopupMenuItem(value: 'found', child: Text('Tandai Sudah Ditemukan')),
              ],
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: _buildImage(report.imageUrl),
            ),
            const SizedBox(height: 24),
            Text(
              report.title,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF222222),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(Icons.location_on, color: Color(0xFFF875AA), size: 22),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    report.location,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: const Color(0xFFF875AA),
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.calendar_month, color: Colors.grey[400], size: 20),
                const SizedBox(width: 4),
                Text(
                  '${report.date.day.toString().padLeft(2, '0')}-${report.date.month.toString().padLeft(2, '0')}-${report.date.year}',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              report.description,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: const Color(0xFF222222),
              ),
            ),
            const SizedBox(height: 26),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.10),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFFF875AA),
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pelapor: ${report.userName}",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFF875AA),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        report.email,
                        style: GoogleFonts.poppins(
                          color: Colors.grey[500],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isFound
                        ? null
                        : () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                              ),
                              builder: (ctx) => Container(
                                padding: const EdgeInsets.all(28),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.phone, color: Color(0xFFF875AA), size: 40),
                                    const SizedBox(height: 12),
                                    Text(
                                      "Nomor Telepon Pelapor",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFF875AA),
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      report.phone.isNotEmpty ? report.phone : "Tidak ada nomor",
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        letterSpacing: 1.1,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(text: report.phone));
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text("Nomor telah disalin!")),
                                          );
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFF875AA),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 13),
                                        ),
                                        icon: const Icon(Icons.copy, color: Colors.white, size: 19),
                                        label: Text(
                                          "Copy Nomor",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFound ? Colors.grey : const Color(0xFFF875AA),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: Icon(Icons.phone, color: isFound ? Colors.black38 : Colors.white, size: 20),
                    label: Text(
                      "Hubungi",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isFound ? Colors.black38 : Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isFound
                        ? null
                        : () async {
                            final loc = parseLatLng(report.location);
                            if (loc == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Lokasi tidak valid.")),
                              );
                              return;
                            }
                            final url = 'https://www.google.com/maps/search/?api=1&query=${loc.latitude},${loc.longitude}';
                            final uri = Uri.parse(url);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Tidak dapat membuka Google Maps.")),
                              );
                            }
                          },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isFound ? Colors.grey : const Color(0xFFF875AA),
                      side: BorderSide(color: isFound ? Colors.grey : const Color(0xFFF875AA)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: Icon(Icons.map, color: isFound ? Colors.grey : const Color(0xFFF875AA), size: 20),
                    label: Text(
                      "Lihat Lokasi",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isFound ? Colors.grey : const Color(0xFFF875AA),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('/')) {
      try {
        return Image.file(File(imageUrl), height: 220, width: double.infinity, fit: BoxFit.cover);
      } catch (e) {
        return Image.asset('assets/images/placeholder.png', height: 220, width: double.infinity, fit: BoxFit.cover);
      }
    } else if (imageUrl.startsWith('http')) {
      return Image.network(imageUrl, height: 220, width: double.infinity, fit: BoxFit.cover);
    } else {
      return Image.asset('assets/images/placeholder.png', height: 220, width: double.infinity, fit: BoxFit.cover);
    }
  }
}

// Helper class koordinat
class LatLng {
  final double latitude;
  final double longitude;
  LatLng(this.latitude, this.longitude);
}
