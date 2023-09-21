class Enkel::Set < Set
  def ==(other)
    to_a == other.to_a
  end
end
