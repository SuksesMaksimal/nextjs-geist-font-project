import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:plantbuddy/auth/login.dart';
import 'package:plantbuddy/screens/article_page.dart';

class HomePage extends StatelessWidget {
  final String userName;
  
  const HomePage({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 1612,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Stack(
                    children: [
                      // Header section with user greeting
                      Positioned(
                        left: 30,
                        top: 96,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Hai,',
                                style: TextStyle(
                                  color: const Color(0xFF2E2E2E),
                                  fontSize: 24,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: ' $userName',
                                style: TextStyle(
                                  color: const Color(0xFF2E2E2E),
                                  fontSize: 24,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: ' 👋',
                                style: TextStyle(
                                  color: const Color(0xFF2E2E2E),
                                  fontSize: 24,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Logout Button
                      Positioned(
                        right: 30,
                        top: 96,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Keluar',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  content: Text(
                                    'Apakah Anda yakin ingin keluar?',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        'Batal',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(builder: (_) => const LoginPage()),
                                          (route) => false,
                                        );
                                      },
                                      child: Text(
                                        'Ya, Keluar',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 0, 0, 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Colors.red,
                                  size: 18,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Keluar',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 30,
                        top: 134,
                        child: Text(
                          'Jelajahi Tumbuhan Anda!',
                          style: TextStyle(
                            color: const Color(0xFF888888),
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.07,
                          ),
                        ),
                      ),

                      // Green section
                      Positioned(
                        left: -3,
                        top: 186,
                        child: Container(
                          width: MediaQuery.of(context).size.width + 6,
                          height: 216,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF01B14E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 37,
                        top: 269,
                        child: Text(
                          'Jelajahi Segalanya',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 37,
                        top: 309,
                        child: Text(
                          'dengan PlantBuddy App',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // Popular Plants section
                      Positioned(
                        left: 24,
                        top: 429,
                        child: Text(
                          'Tanaman Populer',
                          style: TextStyle(
                            color: const Color(0xFF2E2E2E),
                            fontSize: 17,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 282,
                        top: 433,
                        child: Text(
                          'Lihat Semua',
                          style: TextStyle(
                            color: const Color(0xFF888888),
                            fontSize: 13,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // Filter buttons
                      Positioned(
                        left: 48,
                        top: 486,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF01B14E),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Paling Populer',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 214,
                        top: 486,
                        child: Text(
                          'Terdekat',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFFC4C4C4),
                            fontSize: 13,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 348,
                        top: 486,
                        child: Text(
                          'Terbaru',
                          style: TextStyle(
                            color: const Color(0xFFC4C4C4),
                            fontSize: 13,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // Plant cards section
                      Positioned(
                        left: 1,
                        top: 539,
                        child: Container(
                          width: 366,
                          height: 414,
                          child: Stack(
                            children: [
                              // Peace Lily Card
                              Positioned(
                                left: 25,
                                top: 0,
                                child: Container(
                                  width: 250,
                                  height: 385,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFD9D9D9),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image(
                                      image: AssetImage('assets/images/login_image.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 48,
                                top: 305,
                                child: Container(
                                  width: 204,
                                  height: 55,
                                  decoration: ShapeDecoration(
                                    color: const Color(0x661D1D1D),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0x19FFFFFF),
                                        blurRadius: 9,
                                        offset: Offset(0, 9),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 67,
                                top: 325,
                                child: Text(
                                  'Peace Lily',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 220,
                                top: 327,
                                child: Text(
                                  '4.8',
                                  style: TextStyle(
                                    color: const Color(0xFFC9C8C8),
                                    fontSize: 12,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),

                              // Bird of Paradise Card
                              Positioned(
                                left: 304,
                                top: 6,
                                child: Container(
                                  width: 250,
                                  height: 385,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFD9D9D9),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image(
                                      image: AssetImage('assets/images/login_image.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 327,
                                top: 311,
                                child: Container(
                                  width: 204,
                                  height: 55,
                                  decoration: ShapeDecoration(
                                    color: const Color(0x661D1D1D),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0x19FFFFFF),
                                        blurRadius: 9,
                                        offset: Offset(0, 9),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 342,
                                top: 330,
                                child: Text(
                                  'Bird of Paradise',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Categories section
                      Positioned(
                        left: 24,
                        top: 979,
                        child: Text(
                          'Cari Berdasarkan Kategori',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            height: 1.88,
                          ),
                        ),
                      ),

                      // Category cards
                      Positioned(
                        left: 24,
                        top: 1021,
                        child: Container(
                          width: 345,
                          height: 208,
                          child: Stack(
                            children: [
                              // Flowering Plants Category
                              Positioned(
                                left: 2,
                                top: 0,
                                child: Container(
                                  width: 341,
                                  height: 198,
                                  decoration: ShapeDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/login_image.png'),
                                      fit: BoxFit.cover,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 2,
                                top: 151,
                                child: Container(
                                  width: 341,
                                  height: 47,
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 14,
                                top: 165,
                                child: Text(
                                  'Tanaman Berbunga',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 248,
                                top: 169,
                                child: Text(
                                  'Sedang Populer',
                                  style: TextStyle(
                                    color: const Color(0xFF3A544F),
                                    fontSize: 10,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Suggested Articles section
                      Positioned(
                        left: 30,
                        top: 1259,
                        child: Text(
                          'Artikel Disarankan',
                          style: TextStyle(
                            color: const Color(0xFF2E2E2E),
                            fontSize: 17,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 280,
                        top: 1263,
                        child: Text(
                          'Lihat Semua',
                          style: TextStyle(
                            color: const Color(0xFF888888),
                            fontSize: 13,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // Article cards
                      Positioned(
                        left: 26,
                        top: 1301,
                        child: Container(
                          width: 350,
                          height: 167,
                          child: Stack(
                            children: [
                              // First article card
                              Positioned(
                                left: 0,
                                top: 1,
                                child: Container(
                                  width: 320,
                                  height: 150,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFFFFDFD),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 1,
                                        strokeAlign: BorderSide.strokeAlignOutside,
                                        color: Color.fromRGBO(0, 0, 0, 0.1),
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 26,
                                top: 103,
                                child: Container(
                                  width: 96,
                                  height: 29,
                                  decoration: ShapeDecoration(
                                    color: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 62,
                                top: 112,
                                child: Text(
                                  'Baca',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontFamily: 'Work Sans',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 214,
                                top: 25,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: ShapeDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/login_image.png'),
                                      fit: BoxFit.cover,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 26,
                                top: 35,
                                child: SizedBox(
                                  width: 168,
                                  height: 39,
                                  child: Text(
                                    'Tips Merawat Tanaman Hias Agar Tumbuh Sehat di Rumah',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                      height: 1.71,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Fixed bottom navigation bar
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 84,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 2,
                    offset: Offset(0, 0),
                    spreadRadius: 0.50,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.house_fill,
                        color: const Color(0xFF01B14E),
                        size: 24,
                      ),
                      Text(
                        'Beranda',
                        style: TextStyle(
                          color: const Color(0xFF01B14E),
                          fontSize: 12,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          height: 2.17,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.leaf_arrow_circlepath,
                        color: const Color(0xFFD1D1D1),
                        size: 24,
                      ),
                      Text(
                        'Kebunku',
                        style: TextStyle(
                          color: const Color(0xFFD1D1D1),
                          fontSize: 12,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          height: 2.17,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ArticlePage()),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.doc_text_fill,
                          color: const Color(0xFFD1D1D1),
                          size: 24,
                        ),
                        Text(
                          'Artikel',
                          style: TextStyle(
                            color: const Color(0xFFD1D1D1),
                            fontSize: 12,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            height: 2.17,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.person_fill,
                        color: const Color(0xFFD1D1D1),
                        size: 24,
                      ),
                      Text(
                        'Profil',
                        style: TextStyle(
                          color: const Color(0xFFD1D1D1),
                          fontSize: 12,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          height: 2.17,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
