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
