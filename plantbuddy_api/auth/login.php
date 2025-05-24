<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../config/database.php';

// Get JSON input
$json = file_get_contents("php://input");
$data = json_decode($json);

// Debug logging
error_log("Received login request with data: " . $json);

if (!$data) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'error' => 'invalid_json'
    ]);
    exit();
}

if (empty($data->email) || empty($data->password)) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'error' => 'missing_credentials'
    ]);
    exit();
}

// Proceed with login
try {
    $database = new Database();
    $db = $database->getConnection();

    if (!$db) {
        throw new Exception("Database connection failed");
    }

    // Query untuk mencari pengguna berdasarkan email
    $query = "SELECT id, name, email, password FROM users WHERE email = :email";
    $stmt = $db->prepare($query);
    $stmt->bindParam(':email', $data->email);
    
    if (!$stmt->execute()) {
        throw new Exception("Query execution failed");
    }

    if ($stmt->rowCount() > 0) {
        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        // Debug logging
        error_log("Found user: " . json_encode($row));

        if (password_verify($data->password, $row['password'])) {
            unset($row['password']);
            http_response_code(200);
            echo json_encode([
                'success' => true,
                'user' => $row
            ]);
        } else {
            http_response_code(401);
            echo json_encode([
                'success' => false,
                'error' => 'invalid_credentials',
                'message' => 'Password tidak sesuai'
            ]);
        }
    } else {
        http_response_code(401);
        echo json_encode([
            'success' => false,
            'error' => 'user_not_found',
            'message' => 'Email tidak ditemukan'
        ]);
    }
} catch (Exception $e) {
    error_log("Login error: " . $e->getMessage());
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'server_error',
        'message' => 'Terjadi kesalahan pada server'
    ]);
}
?>
