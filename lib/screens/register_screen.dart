import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final phoneController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _canRegister = false;

  @override
  void initState() {
    super.initState();
    nameController.addListener(_validateInput);
    emailController.addListener(_validateInput);
    passwordController.addListener(_validateInput);
    confirmController.addListener(_validateInput);
    phoneController.addListener(_validateInput);
  }

  void _validateInput() {
    setState(() {
      _canRegister = nameController.text.trim().isNotEmpty &&
          emailController.text.trim().isNotEmpty &&
          passwordController.text.trim().isNotEmpty &&
          confirmController.text.trim().isNotEmpty &&
          phoneController.text.trim().isNotEmpty &&
          passwordController.text == confirmController.text;
    });
  }

  Future<void> _register() async {
    if (!_canRegister) {
      String errorMsg = '';
      if (passwordController.text != confirmController.text) {
        errorMsg = 'Password dan konfirmasi password harus sama!';
      } else {
        errorMsg = 'Semua field wajib diisi!';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
      return;
    }

    final user = User(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final result = await authProvider.register(user);

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrasi berhasil! Silakan login.')),
      );
      // Kembali ke halaman Login (bukan auto login)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email sudah terdaftar!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFFF875AA),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width > 500 ? size.width * 0.2 : 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 24),
                Text(
                  "Register",
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF222222),
                  ),
                ),
                const SizedBox(height: 24),
                // Nama
                TextField(
                  controller: nameController,
                  style: GoogleFonts.poppins(),
                  decoration: InputDecoration(
                    hintText: 'Nama Lengkap',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                // Email
                TextField(
                  controller: emailController,
                  style: GoogleFonts.poppins(),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                // Password
                TextField(
                  controller: passwordController,
                  style: GoogleFonts.poppins(),
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                        child: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Confirm Password
                TextField(
                  controller: confirmController,
                  style: GoogleFonts.poppins(),
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    hintText: 'Konfirmasi Password',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                        child: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // No Handphone (jika ingin disimpan juga)
                TextField(
                  controller: phoneController,
                  style: GoogleFonts.poppins(),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "No Handphone",
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 28),
                // Tombol Register
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _canRegister ? _register : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF875AA),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      textStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      elevation: 2,
                    ),
                    child: const Text('Register'),
                  ),
                ),
                const SizedBox(height: 18),
                // Kembali ke login
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()));
                  },
                  child: Text(
                    "Sudah punya akun? Login",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFF875AA),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
