class Hash

  def method_missing(method_name)
    puts "in the ConfigHash helper with #{method_name}"
    ans = self[method_name]
    puts ans
    ans
  end
end
