# frozen_string_literal: true

class HaltExecution < Enkel::Action
  def call
    respond! :ok, message: "FIRST"
    respond :unprocessable_entity, message: "SECOND"
  end
end

RSpec.describe HaltExecution do
  it "responds with first body response" do
    response = described_class.call

    expect(response.success?).to be true
    expect(response.status).to eq :ok
    expect(response.data[:message]).to eq "FIRST"
  end
end
