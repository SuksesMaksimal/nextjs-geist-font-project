import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantbuddy/services/api_service.dart' as api;
import 'package:logger/logger.dart';
import 'dart:convert';

class ArticleForm extends StatefulWidget {
  final Map<String, dynamic>? article;

  const ArticleForm({
    super.key,
    this.article,
  });

  @override
  State<ArticleForm> createState() => _ArticleFormState();
}

class _ArticleFormState extends State<ArticleForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String? _imageBase64;  // Nullable String
  String? _imageName;    // Nullable String
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  final logger = Logger();  // Initialize logger

  @override
  void initState() {
    super.initState();
    if (widget.article != null) {
      _titleController.text = widget.article!['title'];
      _contentController.text = widget.article!['content'];
      
      // Handle existing image
      if (widget.article!['image_data'] != null) {
        _imageBase64 = widget.article!['image_data'];
        _imageName = 'existing_image.jpg'; // Default name for existing images
        logger.i('Loaded existing image from article');
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
      
      if (file != null) {
        // Read the file as bytes and convert to base64
        final bytes = await file.readAsBytes();
        final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';
        
        setState(() {
          _imageBase64 = base64Image;
          _imageName = file.name;
        });
        
        logger.i('Image picked successfully: ${file.name}');
      }
    } catch (e) {
      logger.e('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Format date as MySQL DATETIME
      final now = DateTime.now();
      final formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} "
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

      final articleData = {
        'title': _titleController.text,
        'content': _contentController.text,
        'published_date': formattedDate,
      };

      if (_imageBase64 != null && _imageName != null) {
        articleData['image'] = _imageBase64!;
        articleData['image_name'] = _imageName!;
      }

      try {
        if (widget.article != null) {
          // For update, include the image only if a new one is selected or keep existing
          if (_imageBase64 != null && _imageBase64!.isNotEmpty) {
            articleData['image'] = _imageBase64!;
            articleData['image_name'] = _imageName ?? 'article_image.jpg';
          } else if (widget.article!['image_data'] != null && widget.article!['image_data'].toString().isNotEmpty) {
            // Keep existing image
            articleData['image'] = widget.article!['image_data'].toString();
            articleData['image_name'] = 'existing_image.jpg';
          }
          
          await api.ApiService.updateArticle(int.parse(widget.article!['id'].toString()), articleData);
          logger.i('Update article successful');
        } else {
          // For create, include image if selected
          if (_imageBase64 != null && _imageBase64!.isNotEmpty) {
            articleData['image'] = _imageBase64!;
            articleData['image_name'] = _imageName ?? 'article_image.jpg';
          }
          
          await api.ApiService.createArticle(articleData);
          logger.i('Create article successful');
        }

        if (mounted) {
          // Show success message before popping
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.article != null 
                  ? 'Artikel berhasil diperbarui' 
                  : 'Artikel berhasil ditambahkan'
              ),
              backgroundColor: Colors.green,
            ),
          );
          
          // Wait a moment for the snackbar to be visible
          await Future.delayed(const Duration(milliseconds: 500));
          
          if (mounted) {
            Navigator.pop(context, true);
          }
        }
      } catch (e) {
        logger.e('Error in form submission: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.article != null ? 'Edit Artikel' : 'Tambah Artikel',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Upload
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _imageBase64 != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Builder(
                                builder: (context) {
                                  try {
                                    final base64Str = _imageBase64!
                                        .split(',')
                                        .last
                                        .replaceAll(RegExp(r'\s+'), '')
                                        .trim();
                                    return Image.memory(
                                      base64Decode(base64Str),
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        logger.e('Error loading selected image: $error');
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.error_outline,
                                                size: 50,
                                                color: Colors.red[400],
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                'Error loading image',
                                                style: TextStyle(
                                                  color: Colors.red[400],
                                                  fontFamily: 'Montserrat',
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  } catch (e) {
                                    logger.e('Error decoding base64: $e');
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            size: 50,
                                            color: Colors.red[400],
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Invalid image format',
                                            style: TextStyle(
                                              color: Colors.red[400],
                                              fontFamily: 'Montserrat',
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: 50,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Tap to add image',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Title Field
                Text(
                  'Judul Artikel',
                  style: TextStyle(
                    color: const Color(0xFF2E2E2E),
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan judul artikel',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Judul tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),

                // Content Field
                Text(
                  'Konten',
                  style: TextStyle(
                    color: const Color(0xFF2E2E2E),
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _contentController,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: 'Tulis konten artikel di sini',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Konten tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF01B14E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            widget.article != null ? 'Simpan Perubahan' : 'Tambah Artikel',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                            ),
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
