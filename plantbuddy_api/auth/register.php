<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../config/database.php';

// Ambil data JSON yang dikirimkan
$data = json_decode(file_get_contents("php://input"));

// Debug: Log data yang diterima
error_log(print_r($data, true)); // Menulis data ke log server

// Cek apakah data yang diperlukan ada dan tidak kosong
if (
    !empty($data->name) &&
    !empty($data->email) &&
    !empty($data->password)
) {
    $database = new Database();
    $db = $database->getConnection();

    // Check if email exists
    $query = "SELECT id FROM users WHERE email = :email";
    $stmt = $db->prepare($query);
    $stmt->bindParam(':email', $data->email);
    $stmt->execute();

    // Debugging: Cek apakah email sudah ada
    error_log("Checking if email exists: " . $data->email);
    if ($stmt->rowCount() > 0) {
        http_response_code(409); // Conflict if email already exists
        echo json_encode(['success' => false, 'error' => 'email_exists']);
        exit();
    }

    // Insert user into the database
    $query = "INSERT INTO users SET name=:name, email=:email, password=:password";
    $stmt = $db->prepare($query);

    // Hash password before saving
    $password_hash = password_hash($data->password, PASSWORD_DEFAULT);

    $stmt->bindParam(':name', $data->name);
    $stmt->bindParam(':email', $data->email);
    $stmt->bindParam(':password', $password_hash);

    if ($stmt->execute()) {
        http_response_code(201); // Created
        echo json_encode(['success' => true, 'userId' => $db->lastInsertId()]);
    } else {
        http_response_code(503); // Service Unavailable
        echo json_encode(['success' => false, 'error' => 'unable_to_register']);
    }
} else {
    http_response_code(400); // Bad Request if any required data is missing
    echo json_encode(['success' => false, 'error' => 'incomplete_data']);
}
?>
