class ConfigObject
  def initialize(filepath, overrides=[])
    @filepath = filepath
    @overrides = overrides
    @query_hash = {}
    create_hash
    # read in the file
    # create the giant hash
    # write method_missing to take in method name and return a query to the hash
    # unresolved: how to deal with overrides that are passed in with initialization
  end

  def create_hash
    lines = []
    File.open(@filepath, 'r') do |file|
      while new_line = file.gets
        lines << new_line[0..-2]
      end
    end

    parse_text(lines)
  end

  def parse_text(lines)
    curr_group = ""
    lines.each do |line|
      next if line.length == 0
      # note: this makes the assumption that nothing kooky happens if there are two or more ; in a line
      # note to self: this is pretty messy.  refactor before turning in
      line_without_comments = line.split(";").first
      line_chars = line_without_comments.chars
      while line_chars[0] == " " || line_chars[0] == "\n"
        line_chars.shift
      end
      line_without_comments = line_chars.reduce(:+)
      next if line_without_comments.nil?

      parsed_line = parse_line(line_without_comments)
      case parsed_line[0]
        when "group" then
          curr_group = parsed_line[1]
          @query_hash[curr_group] = {}
        when "setting_val" then
          setting = parsed_line[1]
          val = parsed_line[2]
          @query_hash[curr_group][setting] = {}
          @query_hash[curr_group][setting][""] = val

        when "setting_val_override" then
          setting = parsed_line[1]
          override = parsed_line[2]
          val = parsed_line[3]
          @query_hash[curr_group][setting][override] = val
       end
    end
  end

  # takes in a line after white space has been ignored
  def parse_line(line)
    # ignore empty lines
    if line.length == 0
      return nil
    # treat these as group headers
    elsif line[0] == "["
      group_name = line[1..-2]
      return ["group", group_name]
    # only look at the piece of the line that comes before the comment
    # does it make sense to do the splitting before passing line to parse_line? probably
    # EDIT: split over ; before calling parse_line, also get rid of whitespace
    else
      setting_value_pair = line.split("=")
      setting = setting_value_pair[0]
      value = setting_value_pair[1]

      setting_chars = setting.chars
      while setting_chars.last == " "
        setting_chars.pop
      end
      setting = setting_chars.reduce(:+)

      value_chars = value.chars
      while value_chars.first == " "
        value_chars.shift
      end
      value = value_chars.reduce(:+)

      # error check to make sure that this parses correctly beforehand -- e.g., has a < and a >
      setting_with_overrides = setting.split("<")
      if setting_with_overrides.length == 1
        return ["setting_val", setting, value]
      else
        setting = setting_with_overrides[0]
        override = setting_with_overrides[1]
        override = override[0..-2]
        return ["setting_val_override", setting, override, value]
      end
    end
  end

  def method_missing(method_name, args=[])
    # calls = method_name.split(".")
    # split the method_name over . to determine how deep in the hash to go
    # perform recursive calls until only one method is being called

    # for now, test by printing method_name
    puts "my method name is #{method_name}"
    puts "my args are #{args}"
    puts method_name == :ftp
    puts @query_hash[method_name.to_s]
  end
end
