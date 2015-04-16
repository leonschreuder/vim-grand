[![Build Status](https://travis-ci.org/meonlol/vim-grand.svg?branch=develop)](https://travis-ci.org/meonlol/vim-grand)


Vim-Grand - a Gradle Android plugin for the vim editor
================================================================================

This is a Vim plugin for Android development using Gradle as a build system,
supporting Robolectric Unit Testing. It is based on the excellent
[hsanson/vim-android](https://github.com/hsanson/vim-android) plugin, except
that it is written mostly in ruby, is unit tested, and exclusively supports
the Gradle build system. If you'd like to use ant/maven, or don't need
unit-testing, maybe hsanson's plugin will do the trick.


BREAKING CHANGES!
--------------------------------------------------------------------------------

Since I've completely rewritten the plugin, things might inexplicably stop
to work. Here's what I've changed:

- The plugin is now written in ruby instead of python (liked it better).
- Calling `gradle ouputPaths` now writes to a different output file.
- The plugin now creates and uses a central import-paths file that you can
  manually customize.


Requirements
--------------------------------------------------------------------------------

- Ruby 1.9.3+
- Android SDK installed with the $ANDROID_HOME environment variable set.
- Gradle 2.0+ (?) or a gradle wrapper in the project.
- [exuberant-ctags](http://ctags.sourceforge.net/) for the `GrandTags` command.
- [scrooloose/syntastic](https://github.com/scrooloose/syntastic) for syntax
  checking.
- [meonlol/javacomplete](https://github.com/meonlol/javacomplete) For code
  completion. My fork might still litter your :messages window a bit, but at
  least it works.

### Recommended

- [Tim Pope's Dispatch](https://github.com/tpope/vim-dispatch) vim-grand will
  run the appropriate commands through it, so vim doesn't get blocked. Highly
  recommended.
- [YouCompleteMe](https://github.com/Valloric/YouCompleteMe) for managing
  additional autocompletion features.


Installation
--------------------------------------------------------------------------------

If you don't use one already, install a package manager plugin like Pathogen
or Vundle. It makes installing as simple as:

_Vundle:_

1. Add the line `Plugin 'hsanson/vim-android'` to your .vimrc
2. Call `:so %` on the updated .vimrc to reload it.
3. Run `:PluginInstall` to let vundle install it for you.

_Pathogen:_

Copy and past into the terminal:

    cd ~/.vim/bundle
    git clone git://github.com/tpope/vim-fugitive.git
    vim -u NONE -c "helptags vim-fugitive/doc" -c q



TODO:
--------------------------------------------------------------------------------

- [ ] Update README
- [ ] Release v0.1

For v0.2

- [ ] Some refactoring (project not clean)
- [ ] add vimdocs
- [ ] GradleInstall should also launch app
- [ ] Integrated testing with jumpable test results
    - [ ] build using Dispatch
    - [ ] parse test-result xml to build quickfix


Features
--------------------------------------------------------------------------------

*:GrandSetup* Sets up all the project paths for javacomplete and syntastic.
When used in combination with the `grand.gradle` script, all paths defined in
your build.gradle will also be used for autocompletion and syntax checking.  
*:GrandTags* Generates a tags file in the background using exuberant-ctags.
This way you can jump to classes (even Androids source files) simply by
pressing `CTRL-]`.  
*:GrandInstall* Installs your project on all connected devices (you'll still
have to manually start the app. It's in the TODO list).

(Got ideas? [Tell me!](https://github.com/meonlol/vim-grand/issues))


Setup
--------------------------------------------------------------------------------

### Output Paths

To have the plugin know what dependencies you have in your project, add this
line to your `build.gradle` file:

```gradle
apply from: 'https://raw.githubusercontent.com/meonlol/vim-grand/refactor/grand.gradle'
```

When you now call `./gradlew outputPaths` on the commandline, a text file is
generated containing gradle's paths. Every time `GrandSetup` is called, this
file is parsed for new paths. So if you change a dependency in build.gradle
run the 'outputPaths' command again and vim-grand will know about it.

### Customize paths

If javacomplete gets slow, it might have to many paths to search. Open the
`.grand_source_paths` file and customize what paths are to be used where,
according to the following rules:

    - some/path       # Path is ignored
    c some/other/path # Used for completion javacomplete only
    s some/jar.jar    # Used for syntastic only
    + some/sources    # Used everywhere


Additional setup for a pleasant experience
--------------------------------------------------------------------------------

These tweaks and mappings for in you .vimrc will make you happy.

### Update tags on save

```VimL
"Run GrandCtags command every time you save a java file
autocmd BufWritePost *.java silent! GrandCtags
```

### Run tests using vim-dispatch

```VimL
"Use vim-dispatch to run gradleTest when you press <leader>ua
autocmd FileType java nnoremap <leader>ua :w<bar>Dispatch gradle test -q<CR>
```

### Output formatting

The formatting of the gradles test output is really messy. I'll try and improve
this soon, but in the mean time, you can use [this
gist](https://gist.github.com/meonlol/c5e84ca21a768fd76a7d) to make it
look acceptable.

### Running one test

Don't want to run all the tests every time? The robolectric plugin does not
support that yet. You can add [this little
gist](https://gist.github.com/meonlol/3f222f8687073c46cd64) to your
build.gradle under `robolectric {}`. Then you can call `gradle test -q
-Dclasses=AwesomeTestClass` from the commandline, or you could use this mapping
from vim:

```VimL
"This runs the robolectric test for the current buffer with <leader>uc
autocmd FileType java nnoremap <leader>uc :w<bar>Dispatch gradle test -q -Dclasses=%:t:r<CR>
```

Contributing
--------------------------------------------------------------------------------

Please do! You know the drill. Just
[issue](https://github.com/meonlol/vim-grand/issues) and
[pull](https://github.com/meonlol/vim-grand/pulls).

License
--------------------------------------------------------------------------------

Copyright (c) Leon Moll. Distributed under the same terms as Vim itself.
See `:help license`.

