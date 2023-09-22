# frozen_string_literal: true

class AddMultipleErrors < Enkel::Action
  def call
    error [{ dog: "FIRST" }, { dog: "SECOND" }]
    error dog: "THIRD", cat: "FIRST"
    error [{ dog: "FOURTH" }, { dog: "FIFTH" }, { cat: "SECOND" }]
  end
end

RSpec.describe AddMultipleErrors do
  it "responds with correct errors" do
    response = described_class.call

    expect(response.success?).to be(false)
    expect(response.status).to eq(:unprocessable_entity)
    expect(response.data).to eq({})
    expect(response.errors).to eq(
      dog: %w[FIRST SECOND THIRD FOURTH FIFTH],
      cat: %w[FIRST SECOND]
    )
  end
end
