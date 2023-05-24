# frozen_string_literal: true

class NoArguments < Enkel::Action
  def call
    respond :ok, "No arguments"
  end
end

RSpec.describe NoArguments do
  it "responds with a message" do
    result = described_class.call

    expect(result.success?).to be true
    expect(result.status).to eq :ok
    expect(result.body).to eq "No arguments"
  end
end
