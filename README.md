METS PDF Document Creator
=========================

Creates a METS PDF Document from METS Guide MD files.

Requirements:

- Pandoc
- Libreoffice

Tested in macOS environment only.

Configuration:

- Download METS Guide (MD files) to ./METS-guide
- Update Libreoffice path in ./md2pdf.sh
- Make ./md2pdf.sh executable

Usage: ./md2pdf.sh

Notes:

- The script assumes that METS Guide is in ./METS-guide directory
- The script creates ./mets-tmp directory temporarily
- THe output PDF is ./mets-combined.pdf

LUA filter "include-files.lua" is created by Albert Krewinkel and is licensed under MIT Lincense.
See: https://github.com/pandoc-ext/include-files
License: https://github.com/pandoc-ext/include-files/blob/main/LICENSE

Other LUA filters have been done with the help of Google Gemini AI.

