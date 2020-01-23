# epub-maker

1. `./download_book.bash` to download the HTML files for a book
1. `./build_epub.bash` to build all the other necessary EPUB files
1. `./compress_epub.bash` to generate an epub file
1. `./validate_epub.bash` to validate the epub



## Notes

Internet Archive seems to only import epub2 documents (no MathML)

Calibre still does not render some Math (but it uses MathJax). I see `Unexpected text node ...` while skimming the book.

a href="..." links sometimes point to content without the version number in the URL. Need an XSLT to remove the version number. Its a bit more annoying because `#` might be in the href

The following attributes are in our HTML but are not valid xhtml:

- group-by
- summary
- valign

