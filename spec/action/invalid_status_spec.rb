class InvalidStatus < Enkel::Action
  def call
    respond :random_error, "Random error"
  end
end

RSpec.describe InvalidStatus do
  it "responds with a server error" do
    result = described_class.call

    expect(result.success?).to be false
    expect(result.status).to eq :internal_server_error
    expect(result.code).to eq 500
    expect(result.body).to eq nil
  end
end
