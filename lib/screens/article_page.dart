import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:plantbuddy/screens/homepage.dart';
import 'package:plantbuddy/screens/detail_article.dart';
import 'package:plantbuddy/services/api_service.dart';

class ArticleCard extends StatelessWidget {
  final Map<String, dynamic> article;
  final Function() onTap;

  const ArticleCard({
    Key? key,
    required this.article,
    required this.onTap,
  }) : super(key: key);

  String _formatPublishedDate(String? publishedDate, String? createdAt) {
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
    return const NetworkImage("https://via.placeholder.com/116x79");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 346,
            height: 161,
            child: Stack(
              children: [
                Positioned(
                  left: 2,
                  top: 0,
                  child: Container(
                    width: 344,
                    height: 161,
                    decoration: ShapeDecoration(
                      color: const Color(0x4C1D1D1D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 344,
                    height: 161,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFF9FCFCA),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 19,
                  top: 33,
                  child: SizedBox(
                    width: 188,
                    height: 39,
                    child: Text(
                      article['title'] ?? 'No Title',
                      style: const TextStyle(
                        color: Color(0xFF2E2E2E),
                        fontSize: 12,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Positioned(
                  left: 301,
                  top: 134,
                  child: Container(
                    width: 25.25,
                    height: 16.66,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Stack(),
                  ),
                ),
            Positioned(
              left: 19,
              top: 75,
              child: SizedBox(
                width: 188.31,
                height: 12,
                child: Text(
                  _formatPublishedDate(article['published_date'], article['created_at']),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 8,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ),
            ),
                Positioned(
                  left: 17,
                  top: 104,
                  child: SizedBox(
                    width: 190,
                    height: 40,
                    child: Text(
                      article['content'] != null && article['content'].toString().length > 100
                          ? '${article['content'].toString().substring(0, 100)}...'
                          : article['content']?.toString() ?? 'No content',
                      style: const TextStyle(
                        color: Color(0xFF888888),
                        fontSize: 10,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Positioned(
                  left: 17,
                  top: 11.96,
                  child: Icon(
                    Icons.local_florist_outlined,
                    size: 15,
                    color: const Color(0xFF01B14E),
                  ),
                ),
            Positioned(
              left: 214,
              top: 18,
              child: Container(
                width: 116,
                height: 79,
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
            ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  List<Map<String, dynamic>> articles = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedArticles = await ApiService.getArticles();
      
      if (!mounted) return;

      if (fetchedArticles.isEmpty) {
        setState(() {
          articles = [];
          isLoading = false;
          errorMessage = 'No articles available';
        });
        return;
      }

      setState(() {
        articles = fetchedArticles;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading articles: $e');
      if (!mounted) return;
      
      setState(() {
        articles = [];
        isLoading = false;
        errorMessage = 'Failed to load articles. Please try again later.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const Group4035(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Artikel Terbaru',
                              style: TextStyle(
                                color: Color(0xFF2E2E2E),
                                fontSize: 17,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Handle see all articles
                              },
                              child: const Text(
                                'Lihat Semua',
                                style: TextStyle(
                                  color: Color(0xFF888888),
                                  fontSize: 13,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (isLoading)
                        const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF01B14E),
                          ),
                        )
                      else if (errorMessage != null)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                errorMessage!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontFamily: 'Montserrat',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadArticles,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF01B14E),
                                ),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      else if (articles.isEmpty)
                        Center(
                          child: Text(
                            'No articles available',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        )
                      else
                        ...articles.map((article) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                          child: ArticleCard(
                            article: article,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailArticlePage(article: article),
                                ),
                              );
                            },
                          ),
                        )).toList(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
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
                shadows: const [
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
                        const Icon(
                          CupertinoIcons.house_fill,
                          color: Color(0xFFD1D1D1),
                          size: 24,
                        ),
                        const Text(
                          'Beranda',
                          style: TextStyle(
                            color: Color(0xFFD1D1D1),
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
                      const Icon(
                        CupertinoIcons.leaf_arrow_circlepath,
                        color: Color(0xFFD1D1D1),
                        size: 24,
                      ),
                      const Text(
                        'Kebunku',
                        style: TextStyle(
                          color: Color(0xFFD1D1D1),
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
                    children: const [
                      Icon(
                        CupertinoIcons.doc_text_fill,
                        color: Color(0xFF01B14E),
                        size: 24,
                      ),
                      Text(
                        'Artikel',
                        style: TextStyle(
                          color: Color(0xFF01B14E),
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
                    children: const [
                      Icon(
                        CupertinoIcons.person_fill,
                        color: Color(0xFFD1D1D1),
                        size: 24,
                      ),
                      Text(
                        'Profil',
                        style: TextStyle(
                          color: Color(0xFFD1D1D1),
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

class Group4035 extends StatelessWidget {
  const Group4035({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 179,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 179,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF01B14E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 166,
                top: 76,
                child: Text(
                  'Artikel',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              ),
              Positioned(
                left: 30,
                top: 118,
                child: Container(
                  width: MediaQuery.of(context).size.width - 60,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        decoration: ShapeDecoration(
                          color: const Color(0xEDFAFAFA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search,
                                color: const Color(0x993C3C43),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  cursorColor: const Color(0xFF01B14E),
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    hintText: 'Cari',
                                    hintStyle: const TextStyle(
                                      color: Color(0x993C3C43),
                                      fontSize: 17,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w400,
                                      height: 1,
                                      letterSpacing: -0.41,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 17,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400,
                                    height: 1,
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
