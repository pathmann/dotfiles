autocmd! BufRead,BufNewFile *.txt  call jinja#AdjustFiletype()
autocmd BufWritePost *.txt call jinja#AdjustFiletype()
