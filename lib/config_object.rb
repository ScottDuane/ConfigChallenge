require_relative 'helper_module'

class ConfigObject
  using Helper
  def initialize(filepath, overrides=[])
    @filepath = filepath
    @overrides = overrides
    @query_hash = Hash.new
    create_hash
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
    curr_group = ""
    lines.each do |line|
      line_without_comments = line.length == 0 ? nil : remove_whitespace(line.split(";").first)
      next if line_without_comments.nil?

      parsed_line = parse_line(line_without_comments)

      case parsed_line[0]
        when "group" then
          curr_group = parsed_line[1].to_sym
          @query_hash[curr_group] = Hash.new
        when "setting_val" then
          setting = parsed_line[1].to_sym
          val = parsed_line[2]
          @query_hash[curr_group][setting] = val
        when "setting_val_override" then
          setting = parsed_line[1].to_sym
          override = parsed_line[2]
          val = parsed_line[3]
          if @overrides.include?(override) || @overrides.include?(override.to_sym)
            @query_hash[curr_group][setting] = val
          end
       end
    end
  end

  def parse_line(line)
    if line.length == 0
      return nil
    elsif line[0] == "["
      group_name = line[1..-2]
      return ["group", group_name]
    else
      setting_value_pair = line.split("=")
      setting = remove_whitespace(setting_value_pair[0])
      setting_with_overrides = setting.split("<")
      value = eval_with_type(remove_whitespace(setting_value_pair[1]))

      if setting_with_overrides.length == 1
        return ["setting_val", setting, value]
      else
        setting = setting_with_overrides[0]
        override = setting_with_overrides[1][0..-2]
        return ["setting_val_override", setting, override, value]
      end
    end
  end

  def eval_with_type(input)
    bool_attempt = eval_as_bool(input)
    return bool_attempt unless bool_attempt.nil?

    num_attempt = eval_as_num(input)
    return num_attempt if num_attempt

    eval_as_string(input)
  end

  def eval_as_bool(input)
    return true if ["yes", "true", "1"].include?(input)
    return false if ["no", "false", "0"].include?(input)
    nil
  end

  # do this with regex? nah, still gotta do the period_count
  def eval_as_num(input)
    period_count = 0
    digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]

    input.chars.each do |char|
      period_count += 1 if char == "."
      return false unless digits.include?(char)
    end

    case period_count
      when 0
        input.to_i
      when 1
        input.to_f
      else
        false
    end
  end

  def eval_as_string(input)
    if input[0] == '"'
      input[1..-2]
    else
      comma_separated = input.split(",")
      comma_separated.length > 1 ? comma_separated : input
    end
  end

  # def remove_whitespace(line)
  #   line_chars = line.chars
  #
  #   while line_chars.first == " " || line_chars.first == "\n"
  #     line_chars.shift
  #   end
  #
  #   while line_chars.last == " " || line_chars.last == "\n"
  #     line_chars.pop
  #   end
  #
  #   line_chars.reduce(:+)
  # end

  def method_missing(method_name, args=[])
    @query_hash[method_name]
  end
end
