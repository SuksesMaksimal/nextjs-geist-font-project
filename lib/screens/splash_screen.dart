import 'package:flutter/material.dart';
import 'landing_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    // Inisialisasi AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Durasi animasi
      vsync: this,
    );

    // Animasi fade
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Setelah 2 detik, mulai animasi dan navigasi ke LandingPage
    Future.delayed(const Duration(seconds: 2), () {
      _controller.forward().then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LandingPage()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition( // Gunakan FadeTransition untuk animasi transisi
          opacity: _opacityAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Perbesar ukuran logo
              SizedBox(
                width: 200,  // Ukuran logo diperbesar
                height: 200, // Ukuran logo diperbesar
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text(
                          'Logo not found',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();  // Jangan lupa untuk dispose controller setelah animasi selesai
    super.dispose();
  }
}
