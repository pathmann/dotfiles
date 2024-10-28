#!/bin/bash
for f in ./*.xml; do
  xdg-mime install "$f"
  echo "remember to run 'xdg-mime default app.desktop filetype' for ${f}"
done

update-mime-database ~/.local/share/mime

echo ""
echo "some applications use the file application to detect the mimetype"
echo "in that case 'perl-file-mimeinfo' is needed"
