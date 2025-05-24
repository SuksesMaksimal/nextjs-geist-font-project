class ApiConfig {
  // Change this to your local IP address when testing on physical devices
  // For Android Emulator use 10.0.2.2, for iOS Simulator use localhost
  static const String baseUrl = 'http://192.168.1.6/plantbuddy/plantbuddy_api';

  
  // API Endpoints
  static const String register = '$baseUrl/auth/register.php';
  static const String login = '$baseUrl/auth/login.php';
  static const String getPlants = '$baseUrl/plants/get_plants.php';
  static const String addPlant = '$baseUrl/plants/add_plant.php';
  // API Endpoints with proper paths
  static const String getArticles = '$baseUrl/articles/get_articles.php';
  static const String getArticle = '$baseUrl/articles/get_article.php';
  static const String addArticle = '$baseUrl/articles/add_article.php';
  static const String updateArticle = '$baseUrl/articles/update_article.php';
  static const String deleteArticle = '$baseUrl/articles/delete_article.php';
}
