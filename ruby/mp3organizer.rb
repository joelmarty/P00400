#!/usr/bin/env/ruby
# coding: utf-8

require 'rbconfig'
include Config
require "audioinfo"

###############################################################################
#
# mp3organizer
# Joël Marty
# November, 1st 2010
#
# for P00400 course at Oxford Brookes University
#
# this progam takes a directory containing a list of audio files as input and
# processes these files with the following algorithm:
#
# for each of the files in the directory:
# - get the artist information
# - create directories for this file using the following scheme :
#   /input_directory/artist/album/
# - put the file in the newly created directory, rename it as 
#   <tracknumber> - <artist>.<extension>
# - build a key/value table that is used to "cache" the directory in which the
#   file must go if a previous file with same artist/album info was already
#   processed
#
# the program supports mp3, ogg, flac, mp4, m4a, ape and wma file formats
# it doesn't check for filesystem errors due to special characters
# in the metadata of the files
#
# prerequisites:
# - this program has NOT been tested on windows but it should work provided
#   there are no special characters in the file's metadata, I recommend using
#   it on an OS using a filesystem with more tolerance to special characters
# - this program requires the ruby-audioinfo gem to be installed on the system
#   - install rubygems along ruby (tested with ruby 1.9.1) on your system
#   - sudo gem install ruby-audioinfo will install the library and its
#     dependencies
#
###############################################################################

usage = "usage: \n ruby mp3organizer.rb \"/path/to/audio/files\""

unless ARGV.length >= 1
    puts "Wrong number of arguments!"
    puts usage
    exit
end

path = ARGV[0]

# test if the path exists
if not File.directory? path
    puts "path is invalid"
    exit
end

# initialize the folder separation character : '\\' for windows, '/' for the
# others
case CONFIG['host_os']
  when /mswin|windows/i
    p = '\\' 
  else
    p = '/'
end

path_cache = {}

# we open the directory
dir = Dir.new(path)

# iterate on its elements
dir.each do |file|
  absolute_file_path = %{#{dir.path}#{file}}
  file_extension = file.split('.').last
  # unless the file is '..' (parent directory), '.' (current directory), 
  # starts with '.' (hidden file) or is a directory, execute the following
  unless file.match(/(^\.\.)|(^\.)/) or File.directory? absolute_file_path
    begin
      # we open the file for metadata
      AudioInfo.open (absolute_file_path) do |info|
        # we create the new file name from tracknumber (with padding) and title
        new_file_name = %{#{"%02d" % info.tracknum} - #{info.title.force_encoding('UTF-8')}.#{file_extension}}
        if path_cache.has_key? info.album
          # if the directory exists, we simply move the file (with renaming)
          FileUtils.mv absolute_file_path, (path_cache[info.album] + p + new_file_name), :verbose => true, :noop => true
        else
          # if not, we create the directory structure and move/rename the file
          new_path = dir.path + info.artist.force_encoding('UTF-8').to_s + p + info.album.force_encoding('UTF-8').to_s
          FileUtils.mkdir_p new_path, :verbose => true
          FileUtils.mv absolute_file_path, (new_path + p + new_file_name ), :verbose => true, :noop => true
          # we crite the path into the hash table
          path_cache[info.album] = new_path
        end
      end
    rescue AudioInfoError => e
      puts "error when opening " + absolute_file_path
      puts "reason:" + e
    end
  end
end

