class NoRespond < Enkel::Action
  def call
  end
end

RSpec.describe NoRespond do
  it "responds with a message" do
    response = described_class.call

    expect(response.success?).to be(true)
    expect(response.status).to eq(:ok)
    expect(response.data).to eq({})
  end
end
