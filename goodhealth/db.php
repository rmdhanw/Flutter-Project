<?php 

ini_set('display_errors',1);
ini_set('display_starup_errors',1);
error_reporting(E_ALL);

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "goodhealth";

try{
      $conn = new PDO("mysql:host=localhost; dbname=goodhealth" , $username, $password);
      $conn->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);
}
catch(PDOException $e){
      echo "Error : ". $e->getMessage();
}

header('Content-Type: application/json; charset=utf-8');

?>



