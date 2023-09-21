class Enkel::Errors
  def initialize(hash = {})
    @hash = {}
  end

  def add(hash)
    if hash.is_a?(Array)
      hash.each do |sub_hash|
        _add(sub_hash)
      end
    else
      _add(hash)
    end
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
    hash.each do |key, value|
      @hash[key] ||= Enkel::Set.new
      @hash[key] += Set.new(Array(value))
    end
  end
end
