[![Build Status](https://travis-ci.org/meonlol/vim-grand.svg?branch=develop)](https://travis-ci.org/meonlol/vim-grand)

### ALPHA STATUS

It's working and looks pretty stable to me (I use it at work every day), but
you will need to do some manual setup and don't expect a completely
frustration-free experience yet either. But hey, you are trying to use vim for
android development, so you must be extremely awesome and so I know you can
take it!

# Vim-Grand - a Gradle Android plugin for the vim editor

This is a Vim plugin for Android development using Gradle as a build system,
supporting Robolectric Unit Testing. It is based on the excellent
[hsanson/vim-android](https://github.com/hsanson/vim-android) plugin, except
that it is be written mostly in python, is unit tested, and is meant for Gradle
only. If you'd like to use ant/maven, or don't need unit-testing, maybe his
plugin will do the trick.


## Setup

This is the setup I have tested with. Please let me know if it's working on
your platform.

- Mac osX 10.6 and 10.9.
- Vim 7.4 (latest version) but since most of the difficult stuff happens in
  python, vim is probably not going to be to picky.
- Exuberant Ctags 5.8
- Python 2.7.8 (latest version) Note: python 3 untested (will probably fail
  miserably)


## Features

- Setting up Syntastic and javacomplete when you `:GrandSetup`.
- Generates a tags file in the background with the `:GrandTags` command.
- Installing to connected devices with the `:GrandInstall` command (you'll have
  to manually start the app, will probably fix that one soon).

(Got ideas? [Tell me!](https://github.com/meonlol/vim-grand/issues))

## Requirements

- [Syntastic](https://github.com/scrooloose/syntastic) for syntax checking.
- [Javacomplete](https://github.com/vim-scripts/javacomplete) for code completion.
- python (see setup)
- Exuberant Ctags (see setup)

### Advised:

- [Tim Pope's Dispatch](https://github.com/tpope/vim-dispatch) vim-grand will
  run the appropriate commands through it, so vim doesn't get blocked.


##Installation

1. Setup an Android project with Robolectric. \
   I use [deckard-gradle](https://github.com/robolectric/deckard-gradle) as a
   starting point.
2. Copy `grand.gradle` to your project \
   This is a gradle plugin that poops out all the paths to the libraries gradle
   uses in your project (including your custom ones). Copy the `grand.gradle`
   file from the vim-grand project folder into the root of your Android
   project.
3. Let gradle know about `grand.gradle` \
   To do this, add the following line to your build.gradle. Right after `apply
   plugin: 'android'` would be a good location. \
   `apply from: 'grand.gradle'`
4. Generate paths file. \
   From the project root run `gradle outputPaths` or `.\gradlew outputPaths`.
   This uses the vim.gradle script to generate a 'gradle-sources' file in the
   root, containing all the paths to the jars gradle uses.
5. Remove useless paths from `gradle-sources` file. \
   This one sucks I know. Sadly, gradle regurgitates all paths it can think of,
   including stuff you will never ever need autocompletion for. And all those
   extra paths will make javacomplete EXTREMELY slow blocking vim entirely!
   You'll have to experiment with it to see which ones you will and which you
   won't need. It's best to start with nothing, adding more paths only
   when you need them. (hint: remember CTRL-C for when you added to much)
6. Enjoy
   Open vim in the project root and run `GrandPaths`. This imports the paths to
   syntastic and javacomplete, and sets up all the commands. Or you can just
   open a java file, it does the same thing.


## Additional setup for a pleasant experience

These tweaks and mappings will make you happy.

### Update tags on save

```VimL
"Run GrandCtags command every time you save a java file
autocmd BufWritePost *.java silent! GrandCtags
```

The `GrandCtags` command runs in the background and doesn't allow multiple
simultaneous runs. So you can just call `GrandCtags` every time you save
without making a mess of the tags file and keeping things up to date.

### 'gradle test' mapping

```VimL
"Use vim-dispatch to run gradleTest
autocmd FileType java nnoremap <leader>ua :w<bar>Dispatch gradle test -q<CR>
```

Runs `gradle test` with Dispatch when you press `<leader>u`. It displays the
result in the quickfix window as soon as gradle is done.

### Output formatting

The build result gradle returns is a little messy (huge understatement). Just
add the code from [this
gist](https://gist.github.com/meonlol/c5e84ca21a768fd76a7d) to your
build.gradle, and it will improve to an acceptable level and look like this:

```
|| (0.229ms)	+ com.example.project.SmellyActivityTest > init_shouldLoadModel
|| (0.179ms)	- com.example.project.SmellyActivityTest > init_shouldLoadDataToViews
|| CategoryActivityTest.java:52:
|| RobolectricTestRunner.java:236:
|| RobolectricTestRunner.java:158:
|| org.junit.ComparisonFailure: expected:<some_cat[egory]> but was:<some_cat[]>
|| (0.207ms)	+ com.example.project.SmellyActivityTest > finishesWithResult
|| 
|| 9 tests completed, 1 failed
```

What do you mean "why don't you make a vim compiler?". I ain't nobody got time
for that! Why don't YOU build one for me if you need one. It doesn't annoy me
enough to be honest, maybe if you guys ask nicely.

### Running one test

Don't want to run all the tests every time? The robolectric plugin does not
support anything fancy like that, just add [this little
gist](https://gist.github.com/meonlol/3f222f8687073c46cd64) to your
build.gradle under `robolectric {}`, to fix it yourself.

You can now call `gradle test -q
-Dclasses=MyAwesomeTestClassInSomeRandomPackage` from the commandline.

Since nobody will want to do that, this mapping will come in real handy. It
will run the test class in the current buffer.

```VimL
"This runs the robolectric test in the current buffer
autocmd FileType java nnoremap <leader>uc :w<bar>Dispatch gradle test -q -Dclasses=%:t:r<CR>
```

## Contributing

Please do! You know the drill. Just
[issue](https://github.com/meonlol/vim-grand/issues) and
[pull](https://github.com/meonlol/vim-grand/pulls).

By the way, the javacomplete classes could still use some tweaking. Hint, Hint.
Wink, wink. \**Points to you, points to class*\*.

## License

Copyright (c) Leon Moll.  Distributed under the same terms as Vim itself.
See `:help license`.
