#!/bin/bash
uuid='7fccc9cf-9b71-44f6-800b-f9457fd64335'

# wget --mirror --adjust-extension --convert-links --page-requisites "https://archive.cnx.org/contents/${uuid}.html"


replace_colons() {
  filename=$1
  filename="${filename//:/-colon-}"
  filename="${filename//@/-at-}"
  echo "${filename}"
}

content_root="./archive.cnx.org/contents"
book_toc="${content_root}/${uuid}.html"
epub_toc="${content_root}/toc.xhtml"

echo "Root file is ${book_toc}"
echo "Building ./META-INF/container.xml"

echo -n 'application/epub+zip' > ./mimetype

[[ -d "./META-INF" ]] || mkdir ./META-INF

echo '<container xmlns="urn:oasis:names:tc:opendocument:xmlns:container" version="1.0">
  <rootfiles>
    <rootfile media-type="application/oebps-package+xml" full-path="thebook.opf" />
  </rootfiles>
</container>' > ./META-INF/container.xml

echo "Validating that META-INF/container.xml is valid XML"
xmllint META-INF/container.xml > /dev/null

echo "Building ./thebook.opf"
echo '<?xml version="1.0" encoding="UTF-8"?><package xmlns="http://www.idpf.org/2007/opf" version="3.0" unique-identifier="uid">
  <metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
    <dc:identifier id="uid">openstax.org.dummy-book-repo.1.0</dc:identifier>
    <dc:title>Import test book</dc:title>
    <dc:creator>Test user</dc:creator>
    <dc:language>en</dc:language>
    <meta property="dcterms:modified">2020-01-01T00:00:00Z</meta>
  </metadata>
  <manifest>' > ./thebook.opf

# Add the ToC
xsltproc clean_toc.xsl "${book_toc}" | xmllint --pretty 1 - > "${epub_toc}"
echo "  <item properties=\"nav\" id=\"nav\" href=\"${epub_toc}\" media-type=\"application/xhtml+xml\" />" >> ./thebook.opf

# Add the cover image
echo "Adding cover image"
echo '  <item properties="cover-image" id="ci" href="cover.svg" media-type="image/svg+xml" />' >> ./thebook.opf
echo '<svg xmlns="http://www.w3.org/2000/svg" width="256" height="256" class="rocket" viewBox="0 0 16 16" version="1.1" aria-hidden="true"><path fill-rule="evenodd" d="M12.17 3.83c-.27-.27-.47-.55-.63-.88-.16-.31-.27-.66-.34-1.02-.58.33-1.16.7-1.73 1.13-.58.44-1.14.94-1.69 1.48-.7.7-1.33 1.81-1.78 2.45H3L0 10h3l2-2c-.34.77-1.02 2.98-1 3l1 1c.02.02 2.23-.64 3-1l-2 2v3l3-3v-3c.64-.45 1.75-1.09 2.45-1.78.55-.55 1.05-1.13 1.47-1.7.44-.58.81-1.16 1.14-1.72-.36-.08-.7-.19-1.03-.34a3.39 3.39 0 01-.86-.63zM16 0s-.09.38-.3 1.06c-.2.7-.55 1.58-1.06 2.66-.7-.08-1.27-.33-1.66-.72-.39-.39-.63-.94-.7-1.64C13.36.84 14.23.48 14.92.28 15.62.08 16 0 16 0z"></path></svg>' > ./cover.svg

# Loop through the resources and make sure references to hem are included in the spine
echo "Adding image resources"
for resource_path in $(find ./archive.cnx.org/resources); do
  if [[ -f "${resource_path}" ]]; then
    media_type=$(file -b --mime-type "${resource_path}")
    filename=$(basename "${resource_path}")
    filename=$(replace_colons "${filename}")
    echo "  <item id=\"id_${filename}\" href=\"${resource_path}\" media-type=\"${media_type}\"/>" >> ./thebook.opf
  fi
done

echo "Adding HTML pages"
for resource_path in $(find ${content_root}); do
  filename=$(basename "${resource_path}")
  filename=$(replace_colons "${filename}")

  if [[ "${filename}" != "${uuid}.html" && "${filename: -5}" == ".html" ]]; then
    echo "  <item properties=\"mathml\" id=\"id_${filename}\" href=\"${resource_path}\" media-type=\"application/xhtml+xml\"/>" >> ./thebook.opf
  fi
done

echo '</manifest>' >> ./thebook.opf

# Optionally add the spine (not in order)
echo "Adding spine"
echo '<spine>' >> ./thebook.opf
echo "  <itemref idref=\"nav\"/>" >> ./thebook.opf
for filename in $(xsltproc get_spine.xsl "${epub_toc}" 2>&1); do
  filename=$(basename "${filename}")
  filename=$(replace_colons "${filename}")
  echo "  <itemref idref=\"id_${filename}\"/>" >> ./thebook.opf
done
echo '</spine>' >> ./thebook.opf


echo '</package>' >> ./thebook.opf


echo "Validating that ./thebook.opf is valid XML"
xmllint ./thebook.opf > /dev/null




# Notes
# https://github.com/kovidgoyal/calibre/blob/68febe94ca2baf2a0979668b7b61a1e3b0432f0f/src/calibre/ebooks/oeb/polish/container.py#L677
# https://github.com/kovidgoyal/calibre/blob/master/src/calibre/ebooks/oeb/polish/cover.py


# calibre, version 4.8.0
# ERROR: Loading book failed: Failed to open the book at /Users/phil/Downloads/epub-books/Archive.zip.epub. Click "Show details" for more info.

# Traceback (most recent call last):
#   File "site-packages/calibre/gui2/viewer/ui.py", line 371, in _load_ebook_worker
#   File "site-packages/calibre/gui2/viewer/convert_book.py", line 234, in prepare_book
#   File "site-packages/calibre/gui2/viewer/convert_book.py", line 191, in do_convert
# ConversionFailure: Failed to convert book: /Users/phil/Downloads/epub-books/Archive.zip.epub with error:
# InputFormatPlugin: EPUB Input running
# on /Users/phil/Downloads/epub-books/Archive.zip.epub
# Failed to run pipe worker with command: from calibre.srv.render_book import viewer_main; viewer_main()
# Python function terminated unexpectedly: 
# Traceback (most recent call last):
#   File "/Applications/calibre.app/Contents/Resources/Python/lib/python2.7/site.py", line 187, in main
#     return run_entry_point()
#   File "/Applications/calibre.app/Contents/Resources/Python/lib/python2.7/site.py", line 121, in run_entry_point
#     return getattr(pmod, func)()
#   File "site-packages/calibre/utils/ipc/worker.py", line 189, in main
#   File "<string>", line 1, in <module>
#   File "site-packages/calibre/srv/render_book.py", line 848, in viewer_main
#   File "site-packages/calibre/srv/render_book.py", line 841, in render_for_viewer
#   File "site-packages/calibre/srv/render_book.py", line 820, in render
#   File "site-packages/calibre/srv/render_book.py", line 621, in process_exploded_book
#   File "site-packages/calibre/srv/render_book.py", line 305, in create_cover_page
#   File "site-packages/calibre/srv/render_book.py", line 256, in find_epub_cover
# StopIteration