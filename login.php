<?php
session_start();
$servername = "localhost";
$username = "webuser";
$password = "password123";
$dbname = "user";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $userss = $_POST["username"];
    $pass = $_POST["password"];

    $sql = "SELECT * FROM users WHERE username='$userss'";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        if (password_verify($pass, $row["password"])) {
            $_SESSION["username"] = $userss;
            $_SESSION["id"] = $row["id"];
            echo "Login successful! <a href='dashboard.php'>Go to Dashboard</a>";
        } else {
            echo "Invalid credentials!";
        }
    } else {
        echo "Invalid credentials!";
    }
}
$conn->close();
error_reporting(E_ALL);
ini_set('display_errors', 1);
?>
<link type="text/css" rel="stylesheet" href="drip.css" />

<form method="POST" class="login">
    Username: <input type="text" name="username" class="user"required><br>
    Password: <input type="password" name="password" class="pass"required><br>
    <button type="submit" class="LButt">Login</button>
</form>


