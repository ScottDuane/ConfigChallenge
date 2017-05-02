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

    group_header_match = /\[[\w\_\-]+\]/ =~ line_without_comments ? true : false
    next if group_header_match

    setting_val_pair = line_without_comments.split("=")
    return false unless setting_val_pair.length == 2

    setting_match = /[\w\d\/\_\:\.\,\*\@\-]+\s?/ =~ setting_val_pair[0]
    setting_override_match = /[\w\d\/\_\:\.\,\*\@\-]+\<\w+\>\s?/ =~ setting_val_pair[0]
    return false unless setting_match || setting_override_match

    str_val = remove_whitespace(setting_val_pair[1])
    string_val_match =  str_val[0] == '"' && str_val[-1] == '"'
    other_val_match = /[\w\d\/\_\:\.\,\*\^\@\-]+/ =~ str_val ? true : false
    return false unless string_val_match || other_val_match
  end

  true
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

def load_config(filename, overrides=[])
  file_lines = parse_file(filename)
  if file_lines.nil?
    raise "Filename is incorrect."
  else
    well_formed = is_well_formed?(file_lines)
    if !well_formed
      raise "File is malformed."
    else
      return ConfigObject.new(filename, overrides)
    end
  end
end
