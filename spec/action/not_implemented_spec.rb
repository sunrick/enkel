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

  context "when debug mode with block" do
    it "raises error" do
      Enkel::Action.debug do
        expect {
          described_class.call
        }.to raise_error Enkel::Action::NotImplementedError
      end
    end
  end

  context "when debug mode enabled" do
    it "raises error" do
      Enkel::Action.debug = true
      expect {
        described_class.call
      }.to raise_error Enkel::Action::NotImplementedError
      Enkel::Action.debug = false

      expect { described_class.call }.to_not raise_error
    end
  end

  context "when debug matcher", :debug do
    it "raises error" do
      expect {
        described_class.call
      }.to raise_error Enkel::Action::NotImplementedError
    end
  end
end
