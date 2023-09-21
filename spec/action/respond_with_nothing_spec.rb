class RespondWithNothing < Enkel::Action
  def call
    respond
  end
end

RSpec.describe RespondWithNothing do
  it "responds with a message" do
    response =described_class.call

    expect(response.success?).to be(true)
    expect(response.status).to eq(:ok)
    expect(response.data).to eq({})
  end
end
