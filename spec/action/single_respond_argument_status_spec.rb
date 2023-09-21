class SingleRespondArgumentStatusSpec < Enkel::Action
  def call
    respond :ok
  end
end

RSpec.describe SingleRespondArgumentStatusSpec do
  it "responds with :ok status" do
    action = described_class.call

    expect(action.success?).to be true
    expect(action.status).to eq :ok
    expect(action.data).to eq({})
  end
end
