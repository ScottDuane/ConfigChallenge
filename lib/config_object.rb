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
        lines << new_line
      end
    end

    parse_text(lines)
  end

  def parse_text(lines)
    lines.each do |line|
      # note: this makes the assumption that nothing kooky happens if there are two or more ; in a line
      line_without_comments = line.split(";").first

      while line_without_comments[0] == " "
        line_without_comments.shift
      end

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

      while setting.last == " "
        setting.pop
      end

      while value.first == " "
        key.shift
      end

      # error check to make sure that this parses correctly beforehand -- e.g., has a < and a >
      setting_with_overrides = setting.split("<")
      if setting_with_overrides.length == 1
        return ["setting_val", setting, val]
      else
        setting = setting_with_overrides[0]
        override = setting_with_overrides[1]
        override.pop
        return ["setting_val_override", setting, override, val]
      end 
    end
  end

  def method_missing(method_name, args=[])
    # calls = method_name.split(".")
    # split the method_name over . to determine how deep in the hash to go
    # perform recursive calls until only one method is being called

    # for now, test by printing method_name
    puts method_name
  end
end
