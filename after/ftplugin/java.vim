if !exists('g:GrandAlreadySetUp')


	"TODO: Test/optimize the compiler
	"silent! execute("compiler android")

	GrandSetup "Sets up the Grand plugin if it's and Android gradle project

	let g:GrandAlreadySetUp = 1
endif

