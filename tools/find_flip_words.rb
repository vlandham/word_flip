#!/usr/bin/env ruby
require 'csv'

dictionary_filename = ARGV[0]
output_filename = "data/flipped_words.csv"

@counts = Hash.new(0)
# def load_words filename
#   words = {}
#   File.open(filename, 'r').each_line do |line|
#     # line = line.chomp.gsub("_", " ").upcase
#     line = line.chomp.upcase
#     if line =~ /[[:punct:]]/
#       @counts['excluded'] += 1
#     else
#       @counts['total'] += 1
#       words[line] = line
#     end
#   end
#   words
# end

def load_words filename
  words = {}
  File.open(filename, 'r').each_line do |line|
    # line = line.chomp.gsub("_", " ").upcase
    line = line.chomp.upcase
    line = line.split("\t")[0]
    if line =~ /[[:punct:]]/
      @counts['excluded'] += 1
    else
      @counts['total'] += 1
      words[line] = line
    end
  end
  words
end


MAPPING = {
  "H" => "H",
  "I" => "I",
  "O" => "O",
  "M" => "W",
  "N" => "N",
  "S" => "S",
  "W" => "M",
  "X" => "X",
  "Z" => "Z",
  " " => " "
}

def flip_word word
  new_word = ""
  word.reverse.each_char {|c| new_word << ((MAPPING[c] != nil) ? MAPPING[c] : "*")}
  new_word
end

puts "loading"
words = load_words(dictionary_filename)
puts "done"

flippable_file = File.open("data/flippable.txt", 'w')

def in_words words, word
  rtn = false
  word_split = word.split(" ")
  found_bools = word_split.map {|a| words[1] != nil}
  if !found_bools.include?(false)
    rtn = true
  end
  # word_split.each do |a_word|
  #   if words[a_word]
  #     rtn = true
  #   end
  # end
  if !rtn
    if words[word]
      rtn = true
    end
  end
 rtn 
end

CSV.open(output_filename, "wb") do |csv|
  csv << ["original", "flipped"]
  words.keys().each do |word|
    flipped = flip_word(word)
    if !(flipped =~ /\*/)
      flippable_file.puts(flipped)
      if in_words words, flipped
        csv << [word, flipped]
        puts [word, flipped].inspect
        @counts['flipped_and_good'] += 1
      end
        @counts['flipped'] += 1
    end
  end
end

puts @counts.inspect

flippable_file.close
