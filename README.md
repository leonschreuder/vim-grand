# Vim-Grand - a Gradle Android plugin

WORK IN PROGRESS!

This is a Vim plugin for Android development using Gradle as a build system, supporting Robolectric Unit Testing. It is based on the excellent [hsanson/vim-android](https://github.com/hsanson/vim-android) plugin, except that it is be written mostly in python, is unit tested (when possible/sane), and is meant for Gradle only.

It is still very much a work in progress, but the following is there:
- getting paths for Syntastic
- generating the (exurbitant) ctags file.

##Setup
Since people are already cloning the repo, here's the setup I'm testing/developing with (I assume you know how to install the plugin with pathogen/vundle, and have already done so).

System:
- Mac osX 10.6 and 10.9.
- Vim 7.4 (latest version)
- Exuberant Ctags 5.8
- Python 2.7.8 (latest version)

Vim plugins:
- [Tim Pope's Dispatch](https://github.com/tpope/vim-dispatch)

##How I got it to work
Notice the 'I' in the title? I'm actively developing (still pre-Alpha), but maybe this will work for you two.

1. Setup an Android project with Robolectric.
   I use [deckard-gradle](https://github.com/robolectric/deckard-gradle) as a starting point.
2. From the vim-grand project folder copy the `vim.gradle` file into your Android project.
3. Add the following line to your build.gradle. Right after `apply plugin: 'android'` would be a good location.
   `apply from: 'vim.gradle'`
4. From the project root run `gradle outputPaths`. This uses the vim.gradle script to generate a 'gradle-sources' file in the root, containing all the paths to the jars gradle uses.
5. Now open vim, in the root and run `GrandPaths`. This imports the paths to syntastic and javacomplete.
6. Run `GrandCtags` to generate a tags file. (`./.ctags`)
It's not quite elegant yet, I know, but I'm working on it, and it's going to be awesome.

##When it's working
If this is also working in your project, you might want to make it easy to use. Try this:
```VimL
"Use vim-dispatch to run gradleTest
autocmd FileType java nnoremap <leader>ua :w<bar>Dispatch gradle test -q<CR>

"Run GrandCtags command every time you save a java file
autocmd BufWritePost *.java silent! GrandCtags
```


Issues and pull-requests are welcome.


##License

Copyright (c) Leon Moll.  Distributed under the same terms as Vim itself.
See `:help license`.
