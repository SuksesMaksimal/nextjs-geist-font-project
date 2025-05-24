import 'package:flutter/material.dart';
import 'package:plantbuddy/services/auth_service.dart';
import 'package:plantbuddy/auth/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Stack(
                  children: [
                    // Header Image
                    Container(
                      width: screenSize.width,
                      height: screenSize.height * 0.4,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/login_image.png'),
                          fit: BoxFit.cover,
                        ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                      ),
                    ),
                    // Back Button
                    Positioned(
                      left: 16,
                      top: 16,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Color(0xFF00B761)),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginPage()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                // Title Text
                Padding(
                  padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.02),
                  child: Text(
                    'Isi data diri anda',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.50,
                    ),
                  ),
                ),
                // Form Fields
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.06),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name Label
                      Text(
                        'Nama Lengkap',
                        style: TextStyle(
                          color: const Color(0xFF7E7B7B),
                          fontSize: 12,
                          fontFamily: 'Work Sans',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8),
                      // Name Input
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.25),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.25),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama lengkap harus diisi';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      // Email Label
                      Text(
                        'Email',
                        style: TextStyle(
                          color: const Color(0xFF7E7B7B),
                          fontSize: 12,
                          fontFamily: 'Work Sans',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8),
                      // Email Input
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.25),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.25),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email harus diisi';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Email tidak valid';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      // Password Label
                      Text(
                        'Kata Sandi',
                        style: TextStyle(
                          color: const Color(0xFF7E7B7B),
                          fontSize: 12,
                          fontFamily: 'Work Sans',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8),
                      // Password Input
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.25),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.25),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: const Color(0xFF7E7B7B),
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kata sandi harus diisi';
                          }
                          if (value.length < 6) {
                            return 'Kata sandi minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenSize.height * 0.05),
                      // Register Button
                      Center(
                        child: SizedBox(
                          width: screenSize.width * 0.64,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _isLoading = true;
                                      });

                                      try {
                                        final authService = AuthService();
                                        final result = await authService.register(
                                          _nameController.text,
                                          _emailController.text,
                                          _passwordController.text,
                                        );

                                        setState(() {
                                          _isLoading = false;
                                        });

                                        if (result['success']) {
                                          if (!context.mounted) return;
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (_) => const LoginPage()),
                                          );
                                        } else {
                                          String errorMessage = result['error'] == 'email_exists'
                                              ? 'Email sudah terdaftar, silakan gunakan email lain'
                                              : 'Terjadi kesalahan saat registrasi. Silakan coba lagi.';

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Row(
                                                children: [
                                                  Icon(Icons.error_outline, color: Colors.white),
                                                  SizedBox(width: 8),
                                                  Expanded(child: Text(errorMessage)),
                                                ],
                                              ),
                                              backgroundColor: Colors.red,
                                              behavior: SnackBarBehavior.floating,
                                              margin: EdgeInsets.only(
                                                bottom: MediaQuery.of(context).size.height - 100,
                                                left: 20,
                                                right: 20,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        setState(() {
                                          _isLoading = false;
                                        });

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Row(
                                              children: const [
                                                Icon(Icons.error_outline, color: Colors.white),
                                                SizedBox(width: 8),
                                                Text('Terjadi kesalahan saat registrasi'),
                                              ],
                                            ),
                                            backgroundColor: Colors.red,
                                            behavior: SnackBarBehavior.floating,
                                            margin: EdgeInsets.only(
                                              bottom: MediaQuery.of(context).size.height - 100,
                                              left: 20,
                                              right: 20,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF01B14E),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    'Daftar',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.03),
                      // Login Link
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sudah punya akun? ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const LoginPage()),
                                );
                              },
                              child: Text(
                                'Masuk',
                                style: TextStyle(
                                  color: const Color(0xFF01B14E),
                                  fontSize: 13,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
