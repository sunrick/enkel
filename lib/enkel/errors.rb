class Enkel::Errors
  def initialize(hash = {})
    @hash = {}
  end

  def add(hash)
    hash.is_a?(Array) ? hash.each { |sub_hash| _add(sub_hash) } : _add(hash)
  end

  def any?
    @hash.any?
  end

  def empty?
    @hash.empty?
  end

  def [](key)
    @hash[key]
  end

  def to_h
    @hash
  end

  def ==(other)
    @hash == other.to_h
  end

  def _add(hash)
    hash.to_h.each do |key, value|
      @hash[key] ||= Enkel::Set.new
      @hash[key] += Set.new(Array(value))
    end
  end
end
