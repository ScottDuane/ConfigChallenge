class Hash
  def method_missing(method_name)
    self[method_name]
  end
end
