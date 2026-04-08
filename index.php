<?php

echo "Hello World<br>";

// simulate external API call
$response = file_get_contents("https://jsonplaceholder.typicode.com/posts/1");

echo "API call completed<br>";

?>


