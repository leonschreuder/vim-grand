# Vim-Grand - a Gradle Android plugin
[![Build Status](https://travis-ci.org/meonlol/vim-grand.svg?branch=develop)](https://travis-ci.org/meonlol/vim-grand)

This is a Vim plugin for Android development using Gradle as a build system, supporting Robolectric Unit Testing. It is based on the excellent [hsanson/vim-android](https://github.com/hsanson/vim-android) plugin, except that it is be written mostly in python, is unit tested, and is meant for Gradle only. If you'd like to use ant/maven, or don't need unit-testing, maybe his plugin will do the trick.

WORK IN PROGRESS!
I'm actively developing this plugin, it's still in Alpha, but please do try it out and let me know what you think. And if you find a bug or are missing an important feature, please [let me know](https://github.com/meonlol/vim-grand/issues) or add it in a fork and submit a pull-request.
Systems I develop on:
- Mac osX 10.6 and 10.9.
- Vim 7.4 (latest version)
- Exuberant Ctags 5.8
- Python 2.7.8 (latest version)

TODO:

- Split the gradle plugin part into another project. It's doesn't really have anything to do with vim-grand functionality, plus that way maybe it can be published to maven.
- Test environment for:
	- ctags
	- gradle (gradlew / system gradle)

##Features

- Setting up the Syntastic and javacomplete paths with the `:GrandSetup` command.
- (Asyncly-) generating the (exurbitant) ctags file with the `:GrandTags` command.
- Installing to connected devices with the `:GrandInstall` command.


##requirements

- [Syntastic](https://github.com/scrooloose/syntastic) for syntax checking.
- [Javacomplete](https://github.com/vim-scripts/javacomplete) for code completion.

Advised
- [Tim Pope's Dispatch](https://github.com/tpope/vim-dispatch) for using the gradle commands asyncly.


##Installation

1. Setup an Android project with Robolectric.
I use [deckard-gradle](https://github.com/robolectric/deckard-gradle) as a starting point. But you will need to update the classpaths to use version 0.13.+ of both the android and the robolectric plugin.
2. From the vim-grand project folder copy the `grand.gradle` file into your Android project.
3. Add the following line to your build.gradle. Right after `apply plugin: 'android'` would be a good location.
   `apply from: 'grand.gradle'`
4. From the project root run `gradle outputPaths`. This uses the vim.gradle script to generate a 'gradle-sources' file in the root, containing all the paths to the jars gradle uses.
5. Now open vim, in the project root and run `GrandPaths`. This imports the paths to syntastic and javacomplete.
6. Run `GrandCtags` to generate a tags file. (`./.ctags`)

It's not quite elegant yet, I know, but I'm working on it, and it's going to be awesome.

##When it's working
If this setup is also working in your project, you might want to make it easy to use. First, you probably want to keep your tags file up to date. Use this autocommand to generate the tags file every time you save your *.java file:
```VimL
"Run GrandCtags command every time you save a java file
autocmd BufWritePost *.java silent! GrandCtags
```

I run my tests through vim-dispatch, so they don't block vim. The following mapping runs the tests with `<leader>ua` and displays the result in the quickfix window as soon as gradle is done.
```VimL
"Use vim-dispatch to run gradleTest
autocmd FileType java nnoremap <leader>ua :w<bar>Dispatch gradle test -q<CR>
```
To format the results more clearly in the Quickfix Window, you will need to add this to the `robolectric {}` task in your build.gradle.
```Groovy
    // Output and format the test results for vim-grand
    afterTest { descriptor, result ->
        //This part prints the class name with short result notation
        def resultChar = ''
        switch (result.resultType) {
            case TestResult.ResultType.SUCCESS:
                resultChar = '+'
                break
            case TestResult.ResultType.FAILURE:
                resultChar = '-'
                break
            default:
                resultChar = '?'
                break
        }
        println "$resultChar $descriptor.className > $descriptor.name"


        //This prints a short stacktrace, ending with the assert description
        if (result.resultType == TestResult.ResultType.FAILURE) {
            result.getException().each {
                it.getStackTrace().each { el ->
                    if (el.getFileName() && !(el.getClassName() =~
                            /^(java.lang|java.util|junit.framework|org.gradle|org.junit|sun.reflect)/)) {

                        println el.getFileName() + ":" + el.getLineNumber() + ":"
                    }
                }
                println it.toString()
            }
        }
    }
```

Don't want to run all the tests every time? The robolectric plugin hasn't got anything built in yet, so use this:
```Groovy
    // Add test classes on the command line. Examples:
    //     gradle test -Dclasses=SomeClassTest          // runs test/java/com/bla/SomeClassTest.java
    //     gradle test -Dclasses=*ActivityTest          // runs all classes who's name ends in ActivityTest.java
    //     gradle test || gradle test -DClasses=all     // both notations include all classes
	def suppliedClasses = System.getProperty('classes', 'all')
	if (suppliedClasses == 'all') {
        println "target: all"
		include '**/*Test.class'
	} else {
        def targetClass = '**/'+suppliedClasses +'.class'
        println "target: " + targetClass
		include targetClass
	}
```
Now this mapping will come in handy. It will run the test class in the current buffer. 
```VimL
"This runs the robolectric test in the current buffer
autocmd FileType java nnoremap <leader>uc :w<bar>Dispatch gradle test -q -Dclasses=%:t:r<CR>
```



Issues and pull-requests are welcome.


##License

Copyright (c) Leon Moll.  Distributed under the same terms as Vim itself.
See `:help license`.
