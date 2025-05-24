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
    // Get article ID from query string
    $id = isset($_GET['id']) ? $_GET['id'] : null;
    
    if (!$id) {
        http_response_code(400);
        echo json_encode(['error' => 'Article ID is required']);
        exit();
    }

    $query = "SELECT id, title, content, published_date, created_at,
              CASE 
                WHEN image_data IS NOT NULL 
                THEN CONCAT('data:image/', image_type, ';base64,', TO_BASE64(image_data))
                ELSE NULL 
              END as image_data,
              image_type
              FROM articles 
              WHERE id = :id";
              
    $stmt = $conn->prepare($query);
    $stmt->bindParam(':id', $id);
    
    if (!$stmt->execute()) {
        throw new Exception("Failed to execute query: " . implode(", ", $stmt->errorInfo()));
    }
    
    $article = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$article) {
        http_response_code(404);
        echo json_encode(['error' => 'Article not found']);
        exit();
    }
    
    echo json_encode([
        'success' => true,
        'data' => $article
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
