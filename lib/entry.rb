require_relative 'config_object.rb'
require 'pathname'

def parse_file(filename)
  if Pathname.new(filename).expand_path.file?
    lines = []
    File.open(filename, 'r') do |file|
      while line = file.gets
        lines << line
      end
    end

    lines
  else
    nil
  end
end

def is_well_formed?(lines)
  lines.each do |line|
    line = remove_whitespace(line)
    next if line.nil? || line.length == 0

    line_without_comments = line.split(";").first
    next if line_without_comments.nil? || line_without_comments.length == 0

    group_header_match = /\[\w*\]/ =~ line_without_comments ? true : false
    setting_val_match = /[a-zA-Z\/\_\:\.\,\*\@0-9]+\s?=\s?[a-zA-Z0-9\/\_\:\`\"\.\,\*\^\@]+/ =~ line_without_comments ? true : false
    setting_val_override_match = /[a-zA-Z\/\_\:\.\,\*\@0-9]+\<\w+\>\s?=\s?[a-zA-Z0-9\/\_\:\`\"\.\,\*\^\@]+/ =~ line_without_comments ? true : false

    next if (group_header_match || setting_val_match) || setting_val_override_match

    return false
  end

  true
end

def match_regex(regex, str)
  regex.match(str)
end

def remove_whitespace(line)
  line_chars = line.chars
  while line_chars.first == " " || line_chars.first == "\n"
    line_chars.shift
  end

  while line_chars.last == " " || line_chars.last == "\n"
    line_chars.pop
  end

  line_chars.reduce(:+)
end
# note: use File.foreach instead of File.read for speed purposes

# Error handling:
# 1) Test to make sure the filename is an actual file
# 2) Run through to make sure the conf file is well-formed
def load_config(filename, overrides=[])
  file_lines = parse_file(filename)
  if file_lines.nil?
    raise "Filename is incorrect."
  else
    well_formed = is_well_formed?(file_lines)
    if !well_formed
      throw "File is malformed."
    else
      return ConfigObject.new(filename, overrides)
    end
  end
end
