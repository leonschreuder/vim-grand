if !has('ruby')
    echo "Error starting vim-grand: Required vim compiled with +ruby"
    finish
endif

let s:script_folder_path = escape( expand( '<sfile>:p:h' ), '\' ) . '/'

" All functionality is completely delegated to ruby so it can be tested
execute "rubyfile ". s:script_folder_path . "grand.rb"

