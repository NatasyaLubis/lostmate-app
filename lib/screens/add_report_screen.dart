import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/map_picker.dart';
import '../models/report.dart';
import '../providers/report_provider.dart';
import '../providers/auth_provider.dart'; // Pastikan import ini!
import 'package:provider/provider.dart';

class AddReportScreen extends StatefulWidget {
  const AddReportScreen({super.key});

  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final phoneController = TextEditingController();
  final List<String> categories = [
    "Elektronik", "Dompet", "Kunci", "Buku", "Lainnya"
  ];
  String selectedCategory = "Elektronik";
  File? _imageFile;

  LatLng? _pickedLocation;
  String? _pickedAddress;

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Ambil dari Kamera'),
              onTap: () async {
                Navigator.pop(ctx);
                final picked = await ImagePicker().pickImage(
                  source: ImageSource.camera, imageQuality: 80,
                );
                if (picked != null) {
                  setState(() => _imageFile = File(picked.path));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Ambil dari Galeri'),
              onTap: () async {
                Navigator.pop(ctx);
                final picked = await ImagePicker().pickImage(
                  source: ImageSource.gallery, imageQuality: 80,
                );
                if (picked != null) {
                  setState(() => _imageFile = File(picked.path));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickLocation() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapPicker(
          onPicked: (latLng) {
            setState(() {
              _pickedLocation = latLng;
              _pickedAddress =
                  "${latLng.latitude.toStringAsFixed(5)}, ${latLng.longitude.toStringAsFixed(5)}";
            });
          },
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_pickedLocation == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Lokasi wajib dipilih di map")));
        return;
      }
      // Ambil user dari Provider agar info pelapor benar
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User belum login!")),
        );
        return;
      }
      final report = Report(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: titleController.text,
        description: descController.text,
        location: _pickedAddress ?? "Unknown",
        imageUrl: _imageFile != null ? _imageFile!.path : 'assets/images/placeholder.png',
        date: DateTime.now(),
        category: selectedCategory,
        phone: phoneController.text,
        userName: user.name,
        email: user.email,
        isFound: false,  // <--- PENTING
      );

      // Tambah laporan secara async dan tunggu sampai selesai
      await Provider.of<ReportProvider>(context, listen: false).addReport(report);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Laporan berhasil ditambah!")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFFF875AA)),
        elevation: 0.5,
        title: Text(
          "Tambah Laporan",
          style: GoogleFonts.poppins(
            color: const Color(0xFFF875AA),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Upload Foto
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFF875AA), width: 2),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: _imageFile == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt, color: Color(0xFFF875AA), size: 38),
                              const SizedBox(height: 6),
                              Text("Upload Foto", style: GoogleFonts.poppins(fontSize: 13)),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(_imageFile!, fit: BoxFit.cover),
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                // Kategori
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: categories
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat, style: GoogleFonts.poppins()),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                    labelText: "Kategori",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (val) => setState(() => selectedCategory = val!),
                ),
                const SizedBox(height: 18),

                // Nama Barang
                TextFormField(
                  controller: titleController,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: "Nama Barang",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Nama barang wajib diisi' : null,
                ),
                const SizedBox(height: 18),

                // Deskripsi
                TextFormField(
                  controller: descController,
                  style: GoogleFonts.poppins(),
                  decoration: InputDecoration(
                    hintText: "Deskripsi",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 2,
                  validator: (value) => value == null || value.isEmpty ? 'Deskripsi wajib diisi' : null,
                ),
                const SizedBox(height: 18),

                // Lokasi (button map picker)
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _pickLocation,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.map, color: Color(0xFFF875AA)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _pickedAddress ?? "Pilih Lokasi di Map",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: _pickedAddress == null ? Colors.grey[500] : Colors.black,
                                    fontWeight: _pickedAddress == null ? FontWeight.normal : FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // No Handphone
                TextFormField(
                  controller: phoneController,
                  style: GoogleFonts.poppins(),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "No Handphone",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'No HP wajib diisi' : null,
                ),
                const SizedBox(height: 28),
                // Tombol Submit
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: Text(
                      "Simpan Laporan",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF875AA),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
