class InitializationError < Enkel::Action
  def initialize(name:)
    @name = name
  end
  def call
    respond name: @name
  end
end

RSpec.describe InitializationError do
  context ".call" do
    it "responds with a server error" do
      response = described_class.call

      expect(response.success?).to be(false)
      expect(response.status).to eq(:internal_server_error)
      expect(response.data).to eq({})
      expect(response.errors).to eq(server: ["internal server error"])
    end
  end
end
