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
<plist version="1.0">
  <dict>
    <key>CFBundleIdentifier</key>
    <string>http</string>
    <key>CFBundleName</key>
    <string>HTTP</string>
    <key>isJavaScriptEnabled</key>
    <true/>
    <key>DocSetPlatformFamily</key>
    <string>http</string>
    <key>dashIndexFilePath</key>
    <string>developer.mozilla.org/en-US/docs/Web/HTTP.html</string>
  </dict>
</plist>
EOF

cat > Contents/Resources/Nodes.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<DocSetNodes version="1.0">
  <TOC>
    <Node type="folder">
      <Name>Documentation</Name>
      <Path>index.html</Path>
    </Node>
  </TOC>
</DocSetNodes>
EOF

#   mv HTML HTML.docset && \
#   /Developer/usr/bin/docsetutil index HTML.docset && \
