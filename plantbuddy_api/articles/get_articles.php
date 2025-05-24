<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

require_once '../config/database.php';

// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Initialize database connection
$database = new Database();
$conn = $database->getConnection();

if (!$conn) {
    http_response_code(500);
    echo json_encode(['error' => 'Database connection failed']);
    exit();
}

try {
    $query = "SELECT id, title, content, published_date, created_at, 
              CASE 
                WHEN image_data IS NOT NULL 
                THEN CONCAT('data:image/', COALESCE(image_type, 'jpeg'), ';base64,', 
                          REPLACE(
                            REPLACE(
                              REPLACE(
                                REPLACE(
                                  TO_BASE64(image_data),
                                  '\n', ''
                                ),
                                '\r', ''
                              ),
                              ' ', ''
                            ),
                            '\t', ''
                          )
                )
                ELSE NULL 
              END as image_data,
              image_type
              FROM articles 
              ORDER BY published_date DESC";
              
    $stmt = $conn->prepare($query);
    
    if (!$stmt->execute()) {
        throw new Exception("Failed to execute query: " . implode(", ", $stmt->errorInfo()));
    }
    
    $articles = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Ensure $articles is always an array
    if (!is_array($articles)) {
        $articles = [];
    }
    
    // Log the number of articles retrieved
    error_log("Retrieved " . count($articles) . " articles");
    error_log("Articles data: " . json_encode($articles));
    
    echo json_encode([
        'success' => true,
        'data' => array_values($articles) // Ensure indexed array is returned
    ]);
    
} catch(PDOException $e) {
    error_log("PDO Error: " . $e->getMessage());
    http_response_code(500);
    echo json_encode([
        'error' => 'Database error: ' . $e->getMessage()
    ]);
} catch(Exception $e) {
    error_log("General Error: " . $e->getMessage());
    http_response_code(500);
    echo json_encode([
        'error' => 'Error: ' . $e->getMessage()
    ]);
}
