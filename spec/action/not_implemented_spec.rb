# frozen_string_literal: true

class NotImplemented < Enkel::Action
end

RSpec.describe NotImplemented do
  it "raises an error when called" do
    expect { described_class.call }.to raise_error(Enkel::Action::NotImplementedError)
  end
end
