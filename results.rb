#!/usr/bin/env ruby
# ruby -n -e 
#
# :testDebug FAILED

if $readingError == nil
    $readingError = false
end


if $readingError
    if /^\s*$/ !~ $_
        puts "READING_ERROR: " + $_
    else
        # puts "...done reading error"
        $readingError = false
    end
elsif $_ =~ /FAILED$/ and !$_.start_with?(":") and !$_.start_with?("BUILD")
    puts "YES: " + $_
    $readingError = true
    # puts "...starts reading error"
else
    # puts "Nope: " + $_
end


# if $_.start_with?("nl")
#     puts "OUT: " + $_
#     # puts "src/test/java/" + $_.gsub(/\./, "\/").sub(/%:t:r/, \"%:t\")
# else
#     puts $_
# end

# if $_.start_with?(\"de\"); puts \"src/test/java/\" + $_.gsub(/\\./, \"\\/\").sub(/%:t:r/, \"%:t\"); else puts $_; end
