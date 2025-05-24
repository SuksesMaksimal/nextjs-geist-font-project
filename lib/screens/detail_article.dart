import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:plantbuddy/screens/homepage.dart';
import 'package:plantbuddy/screens/article_page.dart';

class DetailArticlePage extends StatelessWidget {
  final Map<String, dynamic> article;
  
  const DetailArticlePage({
    super.key,
    required this.article,
  });

  String _formatDate(String? publishedDate, String? createdAt) {
    try {
      if (publishedDate != null && publishedDate.isNotEmpty) {
        final date = DateTime.parse(publishedDate);
        return "${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)} ${date.year}";
      } else if (createdAt != null && createdAt.isNotEmpty) {
        final date = DateTime.parse(createdAt);
        return "${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)} ${date.year}";
      }
    } catch (e) {
      print('Error parsing date: $e');
    }
    return 'Tanggal tidak tersedia';
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    if (month < 1 || month > 12) return '';
    return months[month - 1];
  }

  ImageProvider _getImageProvider(String? imageData) {
    if (imageData != null && imageData.isNotEmpty && imageData.startsWith('data:image')) {
      try {
        // Extract base64 data after the comma
        final base64Data = imageData.split(',')[1];
        final decodedBytes = base64Decode(base64Data);
        return MemoryImage(decodedBytes);
      } catch (e) {
        print('Error decoding image: $e');
      }
    }
    return const NetworkImage("https://via.placeholder.com/800x600");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Stack(
          children: [
            // Scrollable Content
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 84, // Height of bottom navigation bar
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50), // Adjusted to give space for top content
                      // Article Image with back button inside
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 250,
                            decoration: ShapeDecoration(
                              image: DecorationImage(
                                image: _getImageProvider(article['image_data']),
                                fit: BoxFit.cover,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 24,
                            top: 20,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(100),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: const Color(0xFF01B14E),
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Article Title
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          article['title'] ?? 'No Title Available',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            height: 1.20,
                          ),
                        ),
                      ),

                      // Published Date
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          _formatDate(article['published_date'], article['created_at']),
                          style: const TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 10,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            height: 1.20,
                          ),
                        ),
                      ),

                      // Article Content
                      Text(
                        article['content'] ?? 'Content not available for this article.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                          height: 1.67,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom Navigation Bar
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
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage(userName: '')),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.house_fill, color: const Color(0xFFD1D1D1), size: 24),
                          Text(
                            'Beranda',
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
                        Icon(CupertinoIcons.leaf_arrow_circlepath, color: const Color(0xFFD1D1D1), size: 24),
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const ArticlePage()),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.doc_text_fill, color: const Color(0xFF01B14E), size: 24),
                          Text(
                            'Artikel',
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
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.person_fill, color: const Color(0xFFD1D1D1), size: 24),
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
      ),
    );
  }
}
