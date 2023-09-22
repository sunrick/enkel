class BeforeHook < Enkel::Action
  before :validate_name!
  before :append_cheese_to_name
  after :validate_response!
  after :add_cow_comment
  after :uppercase_response_values

  def initialize(name:)
    @name = name
  end

  def validate_name!
    error! name: "dog ain't a name" if @name == "dog"
  end

  def append_cheese_to_name
    @name += " cheese"
  end

  def validate_response!
    error! name: "cow ain't a cheese" if @name == "cow cheese"
  end

  def uppercase_response_values
    data.transform_values!(&:upcase)
  end

  def add_cow_comment
    data[:comment] = "Moo moo!"
  end

  def call
    respond name: @name
  end
end

# TODO: CHECK IF AROUND SHOULD BE AROUND BEFORE + AFTER HOOKS???
RSpec.describe BeforeHook do
  context "when name is valid" do
    around { |example| Enkel::Action.debug { example.run } }

    it "responds successfully" do
      response = described_class.call(name: "goat")

      expect(response.success?).to be(true)
      expect(response.status).to eq(:ok)
      expect(response.data).to eq(name: "GOAT CHEESE", comment: "MOO MOO!")
      expect(response.errors).to eq({})
    end
  end

  context "when name is dog" do
    it "responds with an error" do
      response = described_class.call(name: "dog")

      expect(response.success?).to be(false)
      expect(response.status).to eq(:unprocessable_entity)
      expect(response.data).to eq({})
      expect(response.errors).to eq(name: ["dog ain't a name"])
    end
  end

  context "when name is cow" do
    it "responds with an error" do
      response = described_class.call(name: "cow")

      expect(response.success?).to be(false)
      expect(response.status).to eq(:unprocessable_entity)
      expect(response.data).to eq(name: "cow cheese")
      expect(response.errors).to eq(name: ["cow ain't a cheese"])
    end
  end
end
