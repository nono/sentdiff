#!/usr/bin/env ruby

# Splits paragraphs into sentences, then runs diff on those.
#
# = Why?
# When you're diffing on written text, rather than code, you often have pretty long paragraphs.
# Often, you've made changes on every paragraph, or nearly every one.
# This makes diff pretty useless.
#
# Author::    Daniel Jackoway (mailto:danjdel@gmail.com)
# Author::    Bruno Michel (mailto:bmichel@menfin.info)
# Copyright:: Copyright (c) 2009 Daniel Jackoway
# License::   Distributes under the MIT License (see COPYING file)

class String
  def split_sentences
    gsub(/([\.\?!] *)([A-Z])/, "\\1\n\\2")
  end
end

class Array
  def rand_val
    self[rand(self.length)]
  end
end

def random_chars(num = 1)
  rand_chars = [*('a' .. 'z')] + [*('0' .. '9')]
  (0 ... num).inject("") { |s,_| s + rand_chars.rand_val }
end

def file_with_split_sentences(old)
  contents = File.read(old).split_sentences
  begin newname = "#{old}-sdiff-#{random_chars 5}"; end while File.exists?(newname)
  File.open(newname, "w") { |file| file.write contents.join("\n")}
  newname
end


if $0 == __FILE__
  fnames = ARGV[-2..-1].collect { |f| file_with_split_sentences f }
  system "diff #{ARGV[0...-2].join " "} #{fnames.join " "}"
  #`rm #{fnames.join " "}`
end

