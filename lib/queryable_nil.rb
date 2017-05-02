class NilClass
  def method_missing(method_name)
    nil
  end
end
