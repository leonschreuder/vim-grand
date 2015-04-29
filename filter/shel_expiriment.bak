#!/usr/bin/env ruby

require 'optparse'

$verbose = false

OptionParser.new do |opts|
    opts.on '-v', '--verbose', 'Print verbose messages' do
        puts "opt v"
        $verbose = true
    end
end.parse!


$stdin.each_line do |line|
    if $verbose
        puts "LINE:" + line
    else
        puts line
    end
end
