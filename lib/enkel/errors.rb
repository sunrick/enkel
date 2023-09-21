class Enkel::Errors
  def initialize(hash = {})
    @hash = {}
  end

  def add(key, value)
    @hash[key] ||= []
    @hash[key] << value
  end

  def any?
    @hash.any?
  end

  def empty?
    @hash.empty?
  end

  def to_h
    @hash
  end
end
