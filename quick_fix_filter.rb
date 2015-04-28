#!/usr/bin/env ruby
#
# ruby -n #{this_script}

#TODO: Move to tested class

require 'optparse'

$verbose = false

# OptionParser.new { |opts|
#   opts.on '-v', '--verbose', 'Print verbose messages' do
#       puts "opt v"
#     $verbose = true
#   end
# }

if not defined? $readingError
    $readingError = false
    puts "QuickFix result filtering started ..." if $verbose
end



if $readingError
    if /^\s*$/ !~ $_
        puts $_
    else
        $readingError = false
        puts "...done reading error" if $verbose
    end
elsif $_ =~ /FAILED$/ and !$_.start_with?(":") and !$_.start_with?("BUILD")
    puts "...starts reading error" if $verbose

    whole_words = $_.split(" ")

    whole_words[0] = "src/test/java/" + whole_words[0].gsub(/\./, "\/") + ".java"

    puts whole_words.join(" ")

    $readingError = true
elsif $_.start_with?(":")
    puts $_
elsif $_ =~ /BUILD\ SUCCESSFUL/
    puts $_
else
    puts "Nope: " + $_ if $verbose
end
