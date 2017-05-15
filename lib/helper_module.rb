module Helper
  refine Hash do
    def method_missing(method_name)
      self[method_name]
    end

    def respond_to_missing?(method_name, *args, &block)
      true
    end
  end

  refine NilClass do
    def method_missing(method_name)
      self
    end

    def respond_to_missing?(method_name, *args, &block)
      true
    end
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
end
