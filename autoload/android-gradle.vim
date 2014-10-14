if !has('python')
    echo "Error: Required vim compiled with +python"
    finish
endif

function! AndroidGradle()
python << EOF
import vim

	" Nothing here yet, but it's going to be good.

EOF
endfunction
