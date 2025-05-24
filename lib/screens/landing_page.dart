import 'package:flutter/material.dart';
import 'package:plantbuddy/auth/login.dart'; // Import login page

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _splashData = const [
    {
      "title": "KELOLA KEBUN ANDA DENGAN MUDAH",
      "description":
          "Ubah cara Anda mengelola kebun lebih cepat, lebih mudah, dan lebih cerdas! Tingkatkan efisiensi dan hasil panen dengan solusi manajemen kebun terbaik.",
      "backgroundColor": Color(0xFFE8F5E9),
      "imagePath": "assets/images/kebun_teratur.png",
    },
    {
      "title": "BERKEBUN JADI MAKIN TERJADWAL",
      "description":
          "Susun jadwal berkebun dengan lebih terstruktur, Kelola aktivitas harian kebun agar lebih terorganisir dan efisien.",
      "backgroundColor": Color(0xFFF1F8E9),
      "imagePath": "assets/images/jadwal_kebun.png",
    },
    {
      "title": "TEMUKAN WAWASAN SEPUTAR PERKEBUNAN",
      "description":
          "Temukan tips, info, dan wawasan menarik seputar dunia berkebun semua ada di sini!",
      "backgroundColor": Color(0xFFE0F2F1),
      "imagePath": "assets/images/wawasan_berkebun.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                itemCount: _splashData.length,
                itemBuilder: (context, index) => OnboardingContent(
                  title: _splashData[index]["title"] as String,
                  description: _splashData[index]["description"] as String,
                  backgroundColor:
                      _splashData[index]["backgroundColor"] as Color,
                  imagePath: _splashData[index]["imagePath"] as String,
                  showBackButton: index > 0,
                  onBackPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _splashData.length,
                  (index) => _buildDot(index: index),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (_currentPage == _splashData.length - 1)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF01B14E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Ayo Mulai',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (_currentPage != _splashData.length - 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            _pageController.animateToPage(
                              _splashData.length - 1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          },
                          child: const Text(
                            "Lewati",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: Color(0xFF00B761),
                            size: 30,
                          ),
                          onPressed: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer _buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? const Color(0xFF00B761)
            : Colors.grey.withAlpha(77),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    super.key,
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.imagePath,
    this.showBackButton = false,
    this.onBackPressed,
  });

  final String title;
  final String description;
  final Color backgroundColor;
  final String imagePath;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            margin: const EdgeInsets.only(bottom: 20),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  child: Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text(
                          'Image not found',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    },
                  ),
                ),
                if (showBackButton)
                  Positioned(
                    left: 16,
                    top: 16,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF00B761)),
                      onPressed: onBackPressed,
                    ),
                  ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF00703C),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF4A4A4A),
                    fontSize: 17,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
