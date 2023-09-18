# frozen_string_literal: true

class NoArguments < Enkel::Action
  def call
    respond :ok, message: "No arguments"
  end
end

RSpec.describe NoArguments do
  it "responds with a message" do
    action = described_class.call

    expect(action.success?).to be(true)
    expect(action.status).to eq(:ok)
    expect(action.body).to eq(message: "No arguments")
  end
end
