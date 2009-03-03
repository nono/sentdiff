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

require 'tempfile'


class SentDiff
  def self.split_sentences(str)
    str.gsub(/([\.\?!] *)([A-Z])/, "\\1\n\\2")
  end

  def file_with_split_sentences(old)
    contents = self.class.split_sentences(File.read(old))
    tmpfile  = Tempfile.new(old, '.')
    File.open(tmpfile.path, "w") { |file| file.write(contents) }
    tmpfile
  end

  def initialize(src, dst, options=[])
    tmp   = [src, dst].collect { |f| file_with_split_sentences(f) }
    paths = tmp.map { |t| t.path }
    @diff = `diff #{options * " "} #{paths * " "}`
    tmp.each { |f| f.close! }
  end

  def to_s
    @diff
  end
end


if $0 == __FILE__
  diff = SentDiff.new(ARGV[-2], ARGV[-1], ARGV[0 ... -2])
  puts diff
end

