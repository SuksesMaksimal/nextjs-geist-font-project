import 'package:flutter/material.dart';
import 'package:plantbuddy/services/api_service.dart' as api;
import 'package:intl/intl.dart';
import 'package:plantbuddy/screens/admin/article_form.dart';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:plantbuddy/auth/login.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<dynamic> articles = [];
  bool isLoading = true;
  final logger = Logger();  // Inisialisasi logger

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    if (!mounted) return;
    
    setState(() {
      isLoading = true;
    });

    try {
      logger.i('Fetching articles...'); // Menggunakan logger untuk log
      final fetchedArticles = await api.ApiService.getArticles();
      logger.i('Fetched articles: $fetchedArticles');
      
      if (!mounted) return;
      
      setState(() {
        articles = List<dynamic>.from(fetchedArticles);
        isLoading = false;
      });
    } catch (e) {
      logger.e('Error fetching articles: $e'); // Menggunakan logger untuk log error
      if (!mounted) return;
      
      setState(() {
        isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _deleteArticle(int id) async {
    try {
      setState(() {
        isLoading = true;
      });

      await api.ApiService.deleteArticle(id);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Artikel berhasil dihapus'),
          backgroundColor: Colors.green,
        ),
      );

      await _fetchArticles(); // Refresh the list after deletion
    } catch (e) {
      logger.e('Error deleting article: $e');
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showDeleteConfirmation(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Hapus Artikel',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus artikel ini?',
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
              Navigator.pop(context);
              _deleteArticle(id);
            },
            child: Text(
              'Hapus',
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            Text(
              'PlantBuddy',
              style: TextStyle(
                color: const Color(0xFF01B14E),
                fontSize: 20,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
              ),
            ),
            Spacer(),
            Text(
              'Admin',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              icon: Icon(Icons.logout, color: Colors.red),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Manage Articles',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ArticleForm(),
                      ),
                    );
                    if (result == true) {
                      _fetchArticles();
                    }
                  },
                  icon: Icon(Icons.add),
                  label: Text(
                    'Tambah Artikel',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF01B14E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> article = Map<String, dynamic>.from(articles[index]);
                      final publishedDate = DateTime.parse(article['published_date']);
                      final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(publishedDate);

                      return Card(
                        margin: EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.grey.shade200,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: article['image_data'] != null
                                    ? Builder(
                                        builder: (context) {
                                          try {
                                            final imageData = article['image_data'] as String;
                                            final base64Str = imageData
                                                .split(',')
                                                .last
                                                .replaceAll(RegExp(r'\s+'), '')
                                                .trim();
                                            return Image.memory(
                                              base64Decode(base64Str),
                                              fit: BoxFit.cover,
                                              width: 80,
                                              height: 80,
                                              errorBuilder: (context, error, stackTrace) {
                                                logger.e('Error loading image: $error');
                                                return Container(
                                                  width: 80,
                                                  height: 80,
                                                  color: Colors.grey[200],
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                    color: Colors.grey[400],
                                                  ),
                                                );
                                              },
                                            );
                                          } catch (e) {
                                            logger.e('Error decoding base64: $e');
                                            return Container(
                                              width: 80,
                                              height: 80,
                                              color: Colors.grey[200],
                                              child: Icon(
                                                Icons.image_not_supported,
                                                color: Colors.grey[400],
                                              ),
                                            );
                                          }
                                        },
                                      )
                                    : Image.asset(
                                        'assets/images/placeholder.png',
                                        fit: BoxFit.cover,
                                        width: 80,
                                        height: 80,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: 80,
                                            height: 80,
                                            color: Colors.grey[200],
                                            child: Icon(
                                              Icons.image,
                                              color: Colors.grey[400],
                                            ),
                                          );
                                        },
                                      ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article['title'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Dipublikasikan: $formattedDate',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Color(0xFF01B14E)),
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ArticleForm(
                                            article: article,
                                          ),
                                        ),
                                      );
                                      if (result == true) {
                                        _fetchArticles();
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _showDeleteConfirmation(article['id']),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                '© 2023 PlantBuddy',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
