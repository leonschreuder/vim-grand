" Vim compiler file
" Compiler:		Gradle

" if exists("current_compiler")
"   finish
" endif

let current_compiler = "gradle"

if exists(":CompilerSet") != 2 " for older vims
    command -nargs=* CompilerSet setlocal <args>
endif
  
exec 'CompilerSet makeprg=gradle\ -i\ --console\ plain'
" exec 'CompilerSet makeprg=./gradlew\ --no-color'

" Sample errors:

" :assembleDebugUnitTest UP-TO-DATE
" :testDebug
" com.example.project.AddItemDialogFragmentTest > onSaveListener FAILED
"     android.content.res.Resources$NotFoundException at AddItemDialogFragmentTest.java:41
"
" Also maches:
" src/java/com/example/project/model/DbHelperTest.java|89|java.lang.AssertionError
"

" CompilerSet errorformat=lines starting with a ':' are ignored
"               Empty lines are ignored 
"               match first line containing a '>' and 'FAILED'
"                   matches second line with filename, linenumber and error
"               matches correclty formatted quickfix lines for injection
" 63 tests completed, 57 failed, 1 skipped
CompilerSet errorformat=%-G:%.%#,
            \%-G\\s%#,
            \%E%f\ >\ %.%#,
                \%Z\s%#%m\ at\ %.%#.java:%l,
            \%A%*\\d\ tests\ completed\,\ %*\\d\ failed\,\ %*\\d\ skipped,
            \%-GFAILURE%.%#,
            \%-G*\ %.%#,
            \%-GExecution\ failed%.%#,
            \%-GBUILD\ FAILED%.%#,
            \%-GRun\ with\ --%.%#,
            \%f:%l:%m
