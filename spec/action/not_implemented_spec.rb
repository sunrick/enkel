# frozen_string_literal: true

class NotImplemented < Enkel::Action
end

RSpec.describe NotImplemented do
  it "responds with server error" do
    response = described_class.call

    expect(response.success?).to be(false)
    expect(response.status).to eq(:internal_server_error)
    expect(response.code).to eq(500)
    expect(response.data).to eq({})
  end
end
