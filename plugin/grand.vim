if !has('python')
    echo "Error: Required vim compiled with +python"
    finish
endif


" Get local path for the script, so we can import other files
let s:script_folder_path = escape( expand( '<sfile>:p:h' ), '\' ) . '/'
let s:python_folder_path = s:script_folder_path . '/../python/'

" Start the python file in the scriptdir
function! s:startPyfile(fileName)
	execute "pyfile " . s:python_folder_path . a:fileName
endfunction


" The commands
command! Grand echo "this is only a stub for autocompletion, please supply the rest of the command"

command! GrandSetup call GrandSetup()
function! GrandSetup()
	call s:startPyfile("vim_grand_setup.py")
endfunction

command! GrandTags call GrandTags()
function! GrandTags()
	call s:startPyfile("vim_grand_tags.py")
endfunction

command! GrandInstall call GrandInstall()
function! GrandInstall()
	call s:startPyfile("vim_grand_install.py")
endfunction


function! RunFile()
	execute "pyfile ". s:script_folder_path . "grand.py"
endfunction

