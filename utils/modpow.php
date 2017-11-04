<!DOCTYPE html>
<html><head><title>RSA Math Helper</title>
</head><body><h1 style="text-align: center;">RSA Math Helper</h1>
<p>&nbsp;</p>
<p>This script will compute <i>m<sup>e</sup></i> mod <i>n</i> or 
<i>c<sup>d</sup></i> mod <i>n</i>.</p><hr>

<form method="post" enctype="multipart/form-data" ACTION="modpow.php">
<table style="text-align: left;">
  <tbody>
    <tr>
      <td>Enter the values for:</td>
<td><i>m</i> or <i>c</i>: <input type="text" name="morc"  size="20">,</td><td><i>d</i> or <i>e</i>: <input type="text" name="dore"  size="20">,</td><td><i>n</i>: <input type="text" name="n"  size="20"></td>    </tr>
  </tbody>
</table>
<input type="submit" name="Compute" value="Compute"><p></form><hr>
<?php

// This script requires the installation of php-bcmath package (or the
// specific version: php7.0-bcmath, etc.)

if ( isset($_POST['morc']) && is_numeric($_POST['morc']) && 
     isset($_POST['dore']) && is_numeric($_POST['dore']) && 
     isset($_POST['n']) && is_numeric($_POST['n']) )
  echo "<p>Result: " . $_POST['morc'] . "<sup>" . $_POST['dore'] . "</sup> mod " . 
    $_POST['n'] . " = " . bcpowmod($_POST['morc'],$_POST['dore'],$_POST['n']) . "</p><hr>\n";

if ( isset($_GET['morc']) && is_numeric($_GET['morc']) && 
     isset($_GET['dore']) && is_numeric($_GET['dore']) && 
     isset($_GET['n']) && is_numeric($_GET['n']) )
  echo "<p>Result: " . $_GET['morc'] . "<sup>" . $_GET['dore'] . "</sup> mod " . 
    $_GET['n'] . " = " . bcpowmod($_GET['morc'],$_GET['dore'],$_GET['n']) . "</p><hr>\n";
?>
</body></html>
