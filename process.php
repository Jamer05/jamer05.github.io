<?php
header (‘Location:index.html’);
$handle = fopen(“log.txt”, “a”);
fwrite($handle, $comment);
fclose($handle);
exit;
?>