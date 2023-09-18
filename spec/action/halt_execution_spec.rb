# frozen_string_literal: true

class HaltExecution < Enkel::Action
  def call
    respond! :ok, message: "FIRST"
    respond :unprocessable_entity, message: "SECOND"
  end
end

RSpec.describe HaltExecution do
  it "responds with first body response" do
    action = described_class.call

    expect(action.success?).to be true
    expect(action.status).to eq :ok
    expect(action.body[:message]).to eq "FIRST"
  end
end
