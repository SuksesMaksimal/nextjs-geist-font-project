<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Access-Control-Allow-Headers, Content-Type, Access-Control-Allow-Methods, Authorization, X-Requested-With');

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
    // Get raw input data
    $input = file_get_contents('php://input');
    error_log("Raw input received: " . $input);
    
    // Decode JSON data
    $data = json_decode($input, true);
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception('Invalid JSON: ' . json_last_error_msg());
    }

    if (!isset($data['id']) || !isset($data['title']) || !isset($data['content'])) {
        http_response_code(400);
        echo json_encode([
            'error' => 'Missing required fields',
            'received_data' => $data
        ]);
        exit();
    }

    // Begin transaction
    $conn->beginTransaction();

    try {
        $image_data = null;
        $image_type = null;
        
        // Handle image upload if present
        if (isset($data['image']) && isset($data['image_name'])) {
            $image = $data['image'];
            
            // Extract image type from base64 string
            if (preg_match('/^data:image\/(\w+);base64,/', $image, $type)) {
                $image_type = strtolower($type[1]); // jpg, png, etc.
                $image = preg_replace('/^data:image\/\w+;base64,/', '', $image);
            }
            
            // Decode base64 data
            $image_data = base64_decode($image);
            if ($image_data === false) {
                throw new Exception("Failed to decode base64 image data");
            }

            // Update query with image
            $query = "UPDATE articles SET 
                     title = :title, 
                     content = :content, 
                     published_date = :published_date,
                     image_data = :image_data,
                     image_type = :image_type
                     WHERE id = :id";
        } else {
            // Update query without image
            $query = "UPDATE articles SET 
                     title = :title, 
                     content = :content, 
                     published_date = :published_date
                     WHERE id = :id";
        }
        
        $stmt = $conn->prepare($query);
        if (!$stmt) {
            throw new Exception("Failed to prepare SQL statement");
        }
        
        // Bind common parameters
        $stmt->bindParam(':id', $data['id']);
        $stmt->bindParam(':title', $data['title']);
        $stmt->bindParam(':content', $data['content']);
        $stmt->bindParam(':published_date', $data['published_date']);
        
        // Bind image parameters if present
        if ($image_data !== null) {
            $stmt->bindParam(':image_data', $image_data, PDO::PARAM_LOB);
            $stmt->bindParam(':image_type', $image_type);
        }
        
        // Execute the query
        if (!$stmt->execute()) {
            throw new Exception("Failed to execute SQL statement: " . implode(", ", $stmt->errorInfo()));
        }
        
        // Commit transaction
        $conn->commit();
        
        // Return success response
        echo json_encode([
            'success' => true,
            'message' => 'Article updated successfully',
            'data' => [
                'id' => $data['id'],
                'title' => $data['title'],
                'content' => $data['content'],
                'published_date' => $data['published_date'],
                'has_image' => ($image_data !== null)
            ]
        ]);

    } catch (Exception $e) {
        // Rollback transaction on error
        $conn->rollBack();
        throw $e;
    }

} catch(PDOException $e) {
    error_log("PDO Error: " . $e->getMessage());
    http_response_code(500);
    echo json_encode([
        'error' => 'Database error: ' . $e->getMessage(),
        'trace' => $e->getTraceAsString()
    ]);
} catch(Exception $e) {
    error_log("General Error: " . $e->getMessage());
    http_response_code(500);
    echo json_encode([
        'error' => 'Error: ' . $e->getMessage(),
        'trace' => $e->getTraceAsString()
    ]);
}
