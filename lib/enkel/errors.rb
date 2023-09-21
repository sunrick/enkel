class Enkel::Errors
  def initialize(hash = {})
    @hash = {}
  end

  def add(hash)
    hash.each do |key, value|
      @hash[key] ||= []
      @hash[key] += Array(value)
    end
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

  def ==(other)
    @hash == other.to_h
  end
end
