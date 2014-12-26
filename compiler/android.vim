let current_compiler = 'android'

if exists(":CompilerSet") != 2 " for older vims
    command -nargs=* CompilerSet setlocal <args>
  endif
  
  exec 'CompilerSet makeprg=./gradlew \ --no-color'
  CompilerSet errorformat=\[ant:checkstyle\]\ %f:%l:%c:\ %m,
                          \[ant:checkstyle\]\ %f:%l:\ %m,
                          \%EExecution\ failed\ for\ task\ '%.%#:findBugs'.,%Z>\ %m.\ See\ the\ report\ at:\ file://%f,
                          \%EExecution\ failed\ for\ task\ '%.%#:lint'.,%Z>\ %m,
                          \%f:%l:\ error:\ %m,
                          \%A%f:%l:\ %m,%-Z%p^,%-C%.%#"
