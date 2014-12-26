GrandDetect
if g:isAndroidProject
  silent! execute("compiler android")
  silent! GrandSetup
  GrandTags
endif
