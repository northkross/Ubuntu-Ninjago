<?php
session_start();
if (!isset($_SESSION["username"])) {
    header("Location: login.php");
    exit();
}
?>
<link type="text/css" rel="stylesheet" href="drip.css" />
<h2>Welcome, <?php echo $_SESSION["username"]; ?>!</h2>
<?php if (!isset($_SESSION["username"]) && $_SESSION["username"]=="kur")?>
        <a href="CTF" class="KCTF">Kur's CTF Room</a>


<form action="delete_account.php" method="post" onsubmit="return confirm('Are you sure you want to delete >
    <input type="submit" name="delete" value="Delete My Account">
</form>
<a href="logout.php" class="logout">Logout</a>
