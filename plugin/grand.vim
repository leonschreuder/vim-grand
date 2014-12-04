if !has('python')
    echo "Error: Required vim compiled with +python"
    finish
endif


" Get local path for the script, so we can import other files
let s:script_folder_path = escape( expand( '<sfile>:p:h' ), '\' )
let s:python_folder_path = s:script_folder_path . '/../python/'

" Start the python file in the scriptdir
function! s:startPyfile(fileName)
	execute "pyfile " . s:python_folder_path . a:fileName
endfunction


" The commands

command! GrandPaths call GrandPaths()
function! GrandPaths()
	call s:startPyfile("vim_grand_paths.py")
endfunction

command! GrandTags call GrandTags()
function! GrandTags()
	call s:startPyfile("vim_grand_tags.py")
endfunction

"command! GrandBuild call GrandBuild()
"function! GrandBuild()
	"call s:startPyfile("")
"endfunction


