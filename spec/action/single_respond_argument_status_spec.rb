class SingleRespondArgumentStatusSpec < Enkel::Action
  def call
    respond :ok
  end
end

RSpec.describe SingleRespondArgumentStatusSpec do
  it "responds with :ok status" do
    response =described_class.call

    expect(response.success?).to be true
    expect(response.status).to eq :ok
    expect(response.data).to eq({})
  end
end
