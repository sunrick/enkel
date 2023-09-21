# frozen_string_literal: true

class ErrorHaltExecution < Enkel::Action
  def call
    error! base: "FIRST"
    error base: "SECOND"
  end
end

RSpec.describe ErrorHaltExecution do
  it "responds with first body response" do
    response = described_class.call

    expect(response.success?).to be false
    expect(response.status).to eq :unprocessable_entity
    expect(response.data).to eq({})
    expect(response.errors).to eq(base: ["FIRST"])
  end
end
