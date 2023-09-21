# frozen_string_literal: true

class NoArguments < Enkel::Action
  def call
    respond :ok, message: "No arguments"
  end
end

RSpec.describe NoArguments do
  it "responds with a message" do
    response =described_class.call

    expect(response.success?).to be(true)
    expect(response.status).to eq(:ok)
    expect(response.data).to eq(message: "No arguments")
  end
end
