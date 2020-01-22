epub_file="./thebook.zip.epub"
echo "Compressing to ${epub_file}"

if [[ -f "${epub_file}" ]]; then
  rm "${epub_file}"
fi

# remember to -X to exclude the extra metadata bits for each file
# also, mimetype needs to be the 1st file
zip -q -X -r "${epub_file}" ./mimetype ./META-INF ./thebook.opf ./cover.svg ./archive.cnx.org