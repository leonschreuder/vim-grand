if !has('ruby')
    echo "Error starting vim-grand: Required vim compiled with +ruby"
    finish
endif

" python will be started from the python installation location.
" We save the current plugin-dir in a variable so python can 
" find out where all it's files are at.
let s:script_folder_path = escape( expand( '<sfile>:p:h' ), '\' ) . '/'

execute "rubyfile ". s:script_folder_path . "grand.rb"
execute "ruby Grand.loadPlugin()"
