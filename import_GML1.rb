#!/usr/bin/env ruby

while (line = STDIN.gets) do
  next unless line =~ /\.zip'/
  items = line.split(/'/)
  puts "http://nlftp.mlit.go.jp#{items[5]}"
end
