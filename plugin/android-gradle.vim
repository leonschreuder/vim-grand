if !has('python')
    echo "Error: Required vim compiled with +python"
    finish
endif

let s:script_folder_path = escape( expand( '<sfile>:p:h' ), '\' )
let s:python_folder_path = s:script_folder_path . '/../python/'

function! AndroidGradle()
python << EOF
import vim

# The CWD is not searched for files by default. Add it
import os
import sys
#sys.path.append(os.getcwd())

script_path = vim.eval('s:python_folder_path')
lib_path = os.path.join(script_path, '.') 
print lib_path
sys.path.append(lib_path)

#print sys.path

from PathsResolver import PathsResolver


resolvedClassPaths = PathsResolver().getAllClassPaths()
resolvedSourcePaths = PathsResolver().getAllSourcePaths()
print resolvedClassPaths

vim.command("let $CLASSPATH = '" + ':'.join(resolvedClassPaths) + "'")
vim.command("let $SRCPATH = '" + ':'.join(resolvedSourcePaths) + "'")
vim.command("setlocal path=" + ','.join(resolvedClassPaths))

vim.command("silent! call javacomplete#SetClassPath($CLASSPATH)")
vim.command("silent! call javacomplete#SetSourcePath($SRCPATH)")

EOF
endfunction

command! AndroidSetup call AndroidGradle()

