#!/bin/bash
UUID=${UUID:-7fccc9cf-9b71-44f6-800b-f9457fd64335}

wget --mirror --adjust-extension --convert-links --page-requisites "https://archive.cnx.org/contents/${UUID}.html"

echo "Fixing up un-namespaced <math> elements"

find './archive.cnx.org/contents/' -name '*.html' -print0 | xargs -0 sed -i.bak 's/<math /<m:math xmlns="http:\/\/www.w3.org\/1998\/Math\/MathML" /g'
find './archive.cnx.org/contents/' -name '*.html' -print0 | xargs -0 sed -i.bak 's/<\/math/<\/m:math/g'

echo "Replacing references to '/resources/' with '../resources/'"

find './archive.cnx.org/contents/' -name '*.html' -print0 | xargs -0 sed -i.bak 's/"\/resources/"\.\.\/resources/g'
find './archive.cnx.org/contents/' -name '*.html' -print0 | xargs -0 sed -i.bak 's/ valign=/ data-valign=/g'
find './archive.cnx.org/contents/' -name '*.html' -print0 | xargs -0 sed -i.bak 's/ summary=/ data-summary=/g'
find './archive.cnx.org/contents/' -name '*.html' -print0 | xargs -0 sed -i.bak 's/ group-by=/ data-group-by=/g'

for content_path in $(find ./archive.cnx.org/contents/ -name '*.html'); do
  xsltproc "./massage_content.xsl" "${content_path}" > temp.xml || exit 1
  mv temp.xml "${content_path}"
done