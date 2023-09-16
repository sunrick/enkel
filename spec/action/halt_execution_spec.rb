class HaltExecution < Enkel::Action
  def call
    respond! :ok, "FIRST"
    respond :unprocessable_entity, "SECOND"
  end
end

RSpec.describe HaltExecution do
  it "responds with first body response" do
    result = described_class.call

    expect(result.success?).to be true
    expect(result.status).to eq :ok
    expect(result.body).to eq "FIRST"
  end
end
