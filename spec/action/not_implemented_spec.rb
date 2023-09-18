# frozen_string_literal: true

class NotImplemented < Enkel::Action
end

RSpec.describe NotImplemented do
  it "responds with server error" do
    action = described_class.call

    expect(action.success?).to be false
    expect(action.status).to eq :internal_server_error
    expect(action.code).to eq 500
    expect(action.body).to eq({})
  end

  context "when debug mode with block" do
    it "raises error" do
      Enkel::Action.debug do
        expect { described_class.call }.to raise_error Enkel::Action::NotImplementedError
      end
    end
  end

  context "when debug mode enabled" do
    it "raises error" do
      Enkel::Action.debug = true
      expect { described_class.call }.to raise_error Enkel::Action::NotImplementedError
      Enkel::Action.debug = false
    end
  end
end
