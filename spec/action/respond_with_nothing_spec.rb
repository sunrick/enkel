class RespondWithNothing < Enkel::Action
  def call
    respond
  end
end

RSpec.describe RespondWithNothing do
  it "responds with a message" do
    action = described_class.call

    expect(action.success?).to be(true)
    expect(action.status).to eq(:ok)
    expect(action.data).to eq({})
  end
end
