#!/bin/bash

jar_file="./epubcheck/epubcheck.jar"
epub_file="./thebook.zip.epub"

if [[ ! -f "${jar_file}" ]]; then
  echo "Download https://github.com/w3c/epubcheck/releases and make sure the following file exists ${jar_file}. Version 4.2.2 was used"
  exit 1
fi

if [[ ! -f "${epub_file}" ]]; then
  echo "Run the build/compress script to generate ${epub_file}"
  exit 1
fi


java -jar "${jar_file}" --error "${epub_file}"