# frozen_string_literal: true

class NotImplemented < Enkel::Action
end

RSpec.describe NotImplemented do
  it "responds with server error" do
    action = described_class.call

    expect(action.success?).to be false
    expect(action.status).to eq :internal_server_error
    expect(action.code).to eq 500
    expect(action.data).to eq({})
  end
end
