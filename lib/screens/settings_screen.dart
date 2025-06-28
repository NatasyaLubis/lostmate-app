import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'Pengaturan',
          style: GoogleFonts.poppins(
            color: const Color(0xFFF875AA),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFF875AA)),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 18),
          // Profil user (bisa klik ke profile screen)
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFF875AA),
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(user?.name ?? "-", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            subtitle: Text(user?.email ?? "-", style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700])),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFFF875AA)),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
            },
          ),
          const Divider(height: 1, thickness: 1),
          // Info aplikasi
          ListTile(
            leading: const Icon(Icons.info_outline_rounded, color: Color(0xFFF875AA)),
            title: Text("Tentang Aplikasi", style: GoogleFonts.poppins()),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "Lost Mate",
                applicationVersion: "1.0.0",
                applicationIcon: Image.asset('assets/logo.png', width: 42, height: 42),
                children: [
                  Text("Aplikasi pelaporan dan pencarian barang hilang. © 2025."),
                ],
              );
            },
          ),
          // Kebijakan Privasi (opsional)
          ListTile(
            leading: const Icon(Icons.privacy_tip_rounded, color: Color(0xFFF875AA)),
            title: Text("Kebijakan Privasi", style: GoogleFonts.poppins()),
            onTap: () {
              // Dialog sederhana, bisa diisi teks privacy policy
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Kebijakan Privasi"),
                  content: const Text("Privasi Anda aman di Lost Mate. Data hanya digunakan untuk kebutuhan aplikasi."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Tutup"),
                    ),
                  ],
                ),
              );
            },
          ),
          // Logout
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout, color: Color(0xFFF875AA)),
                label: Text(
                  "Logout",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Color(0xFFF875AA)),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFF875AA)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  foregroundColor: const Color(0xFFF875AA),
                ),
                onPressed: () async {
                  await Provider.of<AuthProvider>(context, listen: false).logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
