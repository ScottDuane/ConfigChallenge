require './config_object.rb'

def parse_file(filename)
  if File.exist?(filename) && File.readable?(filename)
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
    while line.first == " "
      line.shift
    end
  end

  true
end

# Error handling:
# 1) Test to make sure the filename is an actual file
# 2) Run through to make sure the conf file is well-formed
def load_config(filename, overrides=[])
  file_lines = parse_file(filename)
  if file_lines.nil?
    throw "Filename is incorrect."
  else
    well_formed = is_well_formed?(file_lines)
    if !well_formed
      throw "File is malformed."
    else
      return ConfigObject.new(filename, overrides)
    end
  end
end

# Test cases
config = load_config('../test_files/test_file_1.conf')
