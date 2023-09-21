# frozen_string_literal: true

class AddNumbers < Enkel::Action
  def initialize(number_one:, number_two:)
    @number_one = number_one
    @number_two = number_two
  end

  def call
    if @number_one.is_a?(Integer) && @number_two.is_a?(Integer)
      respond :ok, message: @number_one + @number_two
    else
      respond :unprocessable_entity, message: "Invalid data"
    end
  end
end

RSpec.describe AddNumbers do
  it "adds two numbers" do
    response = described_class.call!(number_one: 1, number_two: 2)

    expect(response.success?).to be true
    expect(response.status).to eq :ok
    expect(response.data[:message]).to eq 3
  end

  it "adds two numbers" do
    options = { number_one: 1, number_two: 2 }
    double = described_class.new(**options)

    allow(described_class).to receive(:new).with(**options).and_return(double)

    response = described_class.call(**options)


    expect(response.success?).to be true
    expect(response.status).to eq :ok
    expect(response.data[:message]).to eq 3
  end

  it "responds with an error when given incorrect data" do
    response = described_class.call(number_one: "1", number_two: 2)

    expect(response.success?).to be false
    expect(response.status).to eq :unprocessable_entity
    expect(response.data).to eq message: "Invalid data"
  end
end
