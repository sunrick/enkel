# frozen_string_literal: true

class NotImplemented < Enkel::Action
end

RSpec.describe NotImplemented do
  it "responds with server error" do
    result = described_class.call

    expect(result.success?).to be false
    expect(result.status).to eq :internal_server_error
    expect(result.code).to eq 500
    expect(result.body).to eq nil
  end
end