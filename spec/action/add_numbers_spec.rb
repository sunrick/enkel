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
    action = described_class.call(number_one: 1, number_two: 2)

    expect(action.success?).to be true
    expect(action.status).to eq :ok
    expect(action.data[:message]).to eq 3
  end

  it "adds two numbers" do
    action = described_class.new(number_one: 1, number_two: 2)
    allow(described_class).to receive(:new).and_return(action)

    action.call

    expect(action.success?).to be true
    expect(action.status).to eq :ok
    expect(action.data[:message]).to eq 3
  end

  it "responds with an error when given incorrect data" do
    action = described_class.call(number_one: "1", number_two: 2)

    expect(action.success?).to be false
    expect(action.status).to eq :unprocessable_entity
    expect(action.data).to eq message: "Invalid data"
  end
end
