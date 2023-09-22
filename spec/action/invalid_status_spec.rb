# frozen_string_literal: true

class InvalidStatus < Enkel::Action
  def call
    respond :random_error, message: "Random error"
  end
end

RSpec.describe InvalidStatus do

  context ".call" do
    it "responds with a server error" do
      response = described_class.call

      expect(response.success?).to be false
      expect(response.status).to eq :internal_server_error
      expect(response.code).to eq 500
      expect(response.data).to eq({})
      expect(response.errors).to eq(server: ["internal server error"])
    end

  end

  context ".call!" do
    it "raises error" do
      expect { described_class.call! }.to raise_error(Enkel::Response::InvalidStatusError, "Invalid status: random_error")
    end
  end
end
