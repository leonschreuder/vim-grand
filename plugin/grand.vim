if !has('ruby')
    echo "Error starting vim-grand: Required vim compiled with +ruby"
    finish
endif

"if !has('python')
    "echo "Error starting vim-grand: Required vim compiled with +python"
    "finish
"endif


" python will be started from the python installation location.
" We save the current plugin-dir in a variable so python can 
" find out where all it's files are at.
let s:script_folder_path = escape( expand( '<sfile>:p:h' ), '\' ) . '/'

" Setting up the plugin is completely delegated to python
execute "pyfile ". s:script_folder_path . "grand.py"

"execute "rubyfile ". s:script_folder_path . "grand.rb"
"execute "ruby Grand.new"
