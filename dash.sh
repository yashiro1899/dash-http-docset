#!/bin/bash


mkdir -p HTTP && cd HTTP
httrack \
  --mirror \
  --keep-alive \
  --robots=0 "https://developer.mozilla.org/en-US/docs/Web/HTTP" \
  -n -* +*.css +*css.php +*.ico +*/fonts/* +*.png +*.jpg +*.gif +*.jpeg +*.js '+developer.mozilla.org/en-US/docs/Web/HTTP/*'

rm -rf hts-* && \
mkdir -p Contents/Resources/Documents && \
mv -f *.* Contents/Resources/Documents/

cat > Contents/Info.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleIdentifier</key>
  <string>http</string>
  <key>CFBundleName</key>
  <string>HTTP</string>
  <key>DocSetPlatformFamily</key>
  <string>http</string>
  <key>dashIndexFilePath</key>
  <string>developer.mozilla.org/en-US/docs/Web/HTTP.html</string>
  <key>isDashDocset</key>
  <true/>
  <key>isJavaScriptEnabled</key>
  <true/>
</dict>
</plist>
EOF

cd - && \
cp icon.png HTTP && \
mv HTTP HTTP.docset
node .
