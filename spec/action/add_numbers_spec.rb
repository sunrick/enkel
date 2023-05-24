# frozen_string_literal: true

class AddNumbers < Enkel::Action
  def initialize(number_one:, number_two:)
    @number_one = number_one
    @number_two = number_two
  end

  def call
    if @number_one.is_a?(Integer) && @number_two.is_a?(Integer)
      respond :ok, @number_one + @number_two
    else
      respond :unprocessable_entity, "Invalid data"
    end
  end
end

RSpec.describe AddNumbers do
  it "adds two numbers" do
    result = described_class.call(number_one: 1, number_two: 2)

    expect(result.success?).to be true
    expect(result.status).to eq :ok
    expect(result.body).to eq 3
  end

  it "responds with an error when given incorrect data" do
    result = described_class.call(number_one: "1", number_two: 2)

    expect(result.success?).to be false
    expect(result.status).to eq :unprocessable_entity
    expect(result.body).to eq "Invalid data"
  end
end
