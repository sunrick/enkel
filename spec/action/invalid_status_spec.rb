# frozen_string_literal: true

class InvalidStatus < Enkel::Action
  def call
    respond :random_error, message: "Random error"
  end
end

RSpec.describe InvalidStatus do
  it "responds with a server error" do
    action = described_class.call

    expect(action.success?).to be false
    expect(action.status).to eq :internal_server_error
    expect(action.code).to eq 500
    expect(action.body).to eq({})
  end
end
