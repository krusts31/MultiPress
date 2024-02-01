<?php

// Assuming $argv[1] contains the language code
$lang = $argv[1];
$csvFile = "/tmp/" . $lang . ".csv";

$columnsToPrint = ["name_" . $lang, "description_" . $lang, "small_text_" . $lang, "price", "picture", "meta_description_" . $lang];

$site = $lang . ".bio113-dev.com";

if (($handle = fopen($csvFile, "r")) !== FALSE) {
    $header = fgetcsv($handle); // Assuming the first row contains headers
    $columnsIndex = array_flip($header);

    while (($row = fgetcsv($handle)) !== FALSE) {
        $values = [];
        foreach ($columnsToPrint as $column) {
            // Extracting the required values based on column names
            $values[$column] = $row[$columnsIndex[$column]];
        }

        // For images, creating an array of objects
        $images = json_encode([["src" => "https://" . "bio113.com/th/340x300_6/" . trim($values["picture"], '/')]]);

        $ret = array();
        $command = "wp --url={$site} wc product create " .
                   "--path=/var/www/wordpress " .
                   "--name='" . $values["name_" . $lang] . "' " .
                   "--type=simple " .
                   "--description='" . $values["description_" . $lang] . "' " .
                   "--short_description='" . $values["small_text_" . $lang] . "' " .
                   "--regular_price=" . $values["price"] . " " .
                   "--images='" . $images . "' " .
                   "--user=admin 2>&1";

        exec($command, $ret, $out);
        echo $ret[0] . "\n";
    }
    fclose($handle);
}
?>
