class Enkel::Errors
  def initialize(hash = {})
    @hash = {}
  end

  def add(key, value)
    @hash[key] ||= []
    @hash[key] << value
  end

  def empty?
    @hash.empty?
  end
end
