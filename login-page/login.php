<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $username = $_POST['username'];
    $password = $_POST['password'];
    
    // Dummy check
    if ($username == "admin" && $password == "1234") {
        echo "<h3>Login Successful! Welcome " . $username . "</h3>";
    } else {
        echo "<h3 style='color:red;'>Invalid credentials!</h3>";
    }
}
?>

<h2>Login to Your Account</h2>
<form method="POST" action="">
    <input type="text" name="username" placeholder="Enter Username" required><br><br>
    <input type="password" name="password" placeholder="Enter Password" required><br><br>
    <button type="submit">Login</button>
</form>