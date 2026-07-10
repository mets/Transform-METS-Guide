#!/bin/bash
SOFFICE_PATH='/Applications/LibreOffice.app/Contents/MacOS/soffice'

mkdir ./mets-tmp
find ./METS-guide -iname "*.md" -type f -exec sh -c 'pandoc --lua-filter=add-anchor.lua -f gfm+yaml_metadata_block -t markdown "${0}" -o "./mets-tmp/${0%}"' {} \;
pandoc --lua-filter=include-files.lua --lua-filter=fix-links.lua -f markdown -t markdown chapter-builder.md > ./mets-tmp/mets-combined.md
pandoc --number-sections --reference-doc=template.docx -f markdown -t docx ./mets-tmp/mets-combined.md > ./mets-tmp/mets-combined.docx
$SOFFICE_PATH --headless --convert-to pdf ./mets-tmp/mets-combined.docx
rm -rf ./mets-tmp

