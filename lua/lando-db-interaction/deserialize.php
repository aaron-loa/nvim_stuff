<?php 

$serialization = trim(fgets(STDIN));
$json = json_encode(unserialize($serialization));
fwrite(STDOUT, $json);

return 1;
