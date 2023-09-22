class SingleRespondArgumentObjectSpec < Enkel::Action
  def call
    respond message: "TEST"
  end
end

RSpec.describe SingleRespondArgumentObjectSpec do
  it "responds with :ok status" do
    response = described_class.call

    expect(response.success?).to be(true)
    expect(response.status).to eq(:ok)
    expect(response.data).to eq(message: "TEST")
  end
end
