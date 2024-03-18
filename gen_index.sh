#!/bin/bash

cat << EOF > index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <h3>Tweet Archive</h3>
    <style>
        body {
            font-family: "Helvetica", sans-serif;
            background-color: #000000;
        }
        h3 {
            color: white;
            font-weight: 250;
        }
        a {
            font-family: "Helvetica", sans-serif;
            color: cyan;
        }
        a:visited {
            color: purple;
        }
    </style>
</head>
<body>
    <ul id="subdirectories-list">
EOF

for dir in $(ls -d */ | tac); do
    subdir=$(basename "$dir")

    if [ -f "${dir}index.html" ]; then
        echo "        <li><a href=\"$dir/index.html\">$subdir</a></li>" >> index.html
    fi
done

cat << EOF >> index.html
    </ul>
</body>
</html>
EOF

echo "Archive formatted successfully."

