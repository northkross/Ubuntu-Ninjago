<?php
$servername = "127.0.0.1";
$username = "webuser";
$password = "password123";
$dbname = "user";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $userss = $_POST["username"];
    $pass = password_hash($_POST["password"], PASSWORD_DEFAULT);

    $sql = "INSERT INTO users (username, password) VALUES ('$userss', '$pass')";

    if ($conn->query($sql) === TRUE) {
        echo "Registration successful! <a href='login.php'>Login here</a>";
    } else {
        echo "Error: " . $conn->error;
    }
}
$conn->close();
?>
<link type="text/css" rel="stylesheet" href="drip.css" />

<form method="POST" class="login">
    Username: <input type="text" name="username" class="user"required><br>
    Password: <input type="password" name="password" class="pass"required><br>
    <button type="submit" class="LButt">Register</button>
</form>



