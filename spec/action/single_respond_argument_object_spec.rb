class SingleRespondArgumentObjectSpec < Enkel::Action
  def call
    respond message: "TEST"
  end
end

RSpec.describe SingleRespondArgumentObjectSpec do
  it "responds with :ok status" do
    action = described_class.call

    expect(action.success?).to be true
    expect(action.status).to eq :ok
    expect(action.data).to eq(message: "TEST")
  end
end
