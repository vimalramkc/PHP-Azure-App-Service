<?php

echo "<h2>Hello World</h2>";

// Initialize cURL
$ch = curl_init();

// Set URL to Google
curl_setopt($ch, CURLOPT_URL, "https://www.google.com");

// Return response instead of printing
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

// Optional: ignore SSL (useful for testing)
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

// Execute request
$response = curl_exec($ch);

// Check for errors
if(curl_errno($ch)) {
    echo "cURL Error: " . curl_error($ch);
} else {
    echo "<h3>API Call Successful ✅</h3>";
    
    // Print small portion of response
    echo "<pre>";
    echo substr($response, 0, 500); // first 500 chars
    echo "</pre>";
}

// Close cURL
curl_close($ch);

?>


