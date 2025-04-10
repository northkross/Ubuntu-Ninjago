<?php
$conn = new mysqli("127.0.0.1", "webuser", "password123", "user");
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
echo "Connected successfully!";
$conn->close();
?>
