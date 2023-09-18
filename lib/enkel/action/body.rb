require "ostruct"

class Enkel::Action::Body < OpenStruct
  def ==(other)
    if other.respond_to?(:to_h)
      to_h == other.to_h
    else
      super
    end
  end
end
