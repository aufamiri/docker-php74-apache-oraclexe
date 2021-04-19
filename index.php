<?php 
$conn = oci_pconnect("kpku", "123456", "//kpku-db:1521/XEPDB1");

if (!$conn) { 
    echo "Not connected!";
 }
 else
   echo "yahooooooooo!!!!!!!!!!";

 ?>
