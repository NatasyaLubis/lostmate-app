import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../models/report.dart';
import '../providers/report_provider.dart';
import 'package:provider/provider.dart';

class EditReportScreen extends StatefulWidget {
  final Report report;
  const EditReportScreen({super.key, required this.report});

  @override
  State<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends State<EditReportScreen> {
  late TextEditingController titleController;
  late TextEditingController descController;
  late TextEditingController phoneController;
  late String selectedCategory;
  String? _pickedAddress;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.report.title);
    descController = TextEditingController(text: widget.report.description);
    phoneController = TextEditingController(text: widget.report.phone);
    selectedCategory = widget.report.category;
    _pickedAddress = widget.report.location;
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() => imageFile = File(picked.path));
    }
  }

  Future<void> _saveEdit() async {
    final updatedReport = Report(
      id: widget.report.id,
      title: titleController.text,
      description: descController.text,
      location: _pickedAddress ?? widget.report.location,
      imageUrl: imageFile != null ? imageFile!.path : widget.report.imageUrl,
      date: widget.report.date,
      category: selectedCategory,
      phone: phoneController.text,
      userName: widget.report.userName,
      email: widget.report.email,
      isFound: widget.report.isFound,
    );

    await Provider.of<ReportProvider>(context, listen: false).updateReport(updatedReport);

    // Kembali ke halaman detail dengan report yang sudah diupdate
    Navigator.pop(context, updatedReport);
  }

  @override
  Widget build(BuildContext context) {
    final categories = ["Elektronik", "Dompet", "Kunci", "Buku", "Lainnya"];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Edit Laporan",
          style: GoogleFonts.poppins(color: const Color(0xFFF875AA), fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFF875AA)),
        elevation: 0.5,
      ),
      backgroundColor: const Color(0xFFFDF6F0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFF875AA), width: 2),
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white,
                ),
                child: imageFile != null
                  ? Image.file(imageFile!, fit: BoxFit.cover)
                  : (widget.report.imageUrl.startsWith("/")
                      ? Image.file(File(widget.report.imageUrl), fit: BoxFit.cover)
                      : Image.asset('assets/images/placeholder.png')),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: categories.map((cat) => DropdownMenuItem(
                value: cat, child: Text(cat, style: GoogleFonts.poppins()),
              )).toList(),
              decoration: InputDecoration(
                labelText: "Kategori",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                filled: true, fillColor: Colors.white,
              ),
              onChanged: (val) => setState(() => selectedCategory = val!),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: titleController,
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                hintText: "Nama Barang",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                filled: true, fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: descController,
              style: GoogleFonts.poppins(),
              maxLines: 2,
              decoration: InputDecoration(
                hintText: "Deskripsi",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                filled: true, fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: phoneController,
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                hintText: "No Handphone",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                filled: true, fillColor: Colors.white,
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveEdit,
                icon: const Icon(Icons.save),
                label: Text(
                  "Simpan Perubahan",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF875AA),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
