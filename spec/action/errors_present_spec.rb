class ErrorsPresent < Enkel::Action
  def call
    error :random_error, "look this is not good"
  end
end

RSpec.describe ErrorsPresent do
  context ".call" do
    it "responds with a unprocessable_entity error" do
      response = described_class.call

      expect(response.success?).to be false
      expect(response.status).to eq :unprocessable_entity
      expect(response.code).to eq 422
      expect(response.data).to eq({})
    end

  end

  context ".call!" do
    it "raises error" do
      expect { described_class.call! }.to raise_error(Enkel::Response::Errors, "Errors present")
    end

    it "has errors" do
      described_class.call!
    rescue Enkel::Response::Errors => error
      expect(error.errors.any?).to be true
      expect(error.errors.to_h).to eq({ random_error: ["look this is not good"] })
    end
  end
end
