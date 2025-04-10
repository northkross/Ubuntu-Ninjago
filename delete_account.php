<?php
session_start();
require 'db_connect.php'; // <- Your file that connects to the database

// Check if user is logged in
if (!isset($_SESSION['username'])) {
    echo "You must be logged in.";
    exit;
}

$user_id = $_SESSION['id'];

echo $user_id;
$sql = "DELETE FROM users WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $user_id);
$stmt->execute();

// Delete user from database

if ($stmt->execute()) {
    echo "Your account has been deleted.";
    // Destroy session and redirect
    session_destroy();
    header("Location: login.php"); // Show a goodbye page or redirect to home
    exit;
} else {
    echo "Error deleting account: " . $conn->error;
}
?>
