class User
  attr_accessor :first_name, :last_name

  def initialize(first_name:, last_name:)
    @first_name = first_name
    @last_name = last_name
  end

  def save
    unless first_name.is_a?(String)
      errors[:first_name] = ["must be a string"]
    end

    unless last_name.is_a?(String)
      errors[:last_name] = ["must be a string"]
    end

    errors.empty?
  end

  def errors
    @errors ||= {}
  end
end

class CreateUser < Enkel::Action
  def initialize(params:)
    @params = params
  end

  def validate!
    if @params[:first_name].nil?
      error first_name: ["can't be blank"]
    end

    if @params[:last_name].nil?
      error last_name: ["can't be blank"]
    end

    respond! :unprocessable_entity, message: "User not created" if errors?
  end

  def call
    validate!

    user = User.new(
      first_name: @params[:first_name],
      last_name: @params[:last_name]
    )

    if user.save
      respond :ok, user: user
    else
      error user.errors
      respond :unprocessable_entity, message: "User not created"
    end
  end
end

RSpec.describe CreateUser do
  context "when given valid params" do
    it "creates a user" do
      response = described_class.call!(
        params: { first_name: "John", last_name: "Doe" }
      )

      expect(response.success?).to be true
      expect(response.status).to eq :ok
      expect(response.data[:user].first_name).to eq("John")
      expect(response.data[:user].last_name).to eq("Doe")
    end
  end

  context "when given invalid params" do
    context "when first_name is missing" do
      it "responds with an error" do
        response = described_class.call(params: { last_name: "Doe" })

        expect(response.success?).to be false
        expect(response.status).to eq :unprocessable_entity
        expect(response.data).to eq(message: "User not created")
        expect(response.errors).to eq(first_name: ["can't be blank"])
      end
    end

    context "when last_name is missing" do
      it "responds with an error" do
        response = described_class.call(params: { first_name: "John" })

        expect(response.success?).to be false
        expect(response.status).to eq :unprocessable_entity
        expect(response.data).to eq(message: "User not created")
        expect(response.errors).to eq(last_name: ["can't be blank"])
      end
    end

    context "when first_name is not a string" do
      it "responds with an error" do
        response = described_class.call(params: { first_name: 1, last_name: "Doe" })

        expect(response.success?).to be false
        expect(response.status).to eq :unprocessable_entity
        expect(response.data).to eq(message: "User not created")
        expect(response.errors).to eq(first_name: ["must be a string"])
      end
    end

    context "when last_name is not a string" do
      it "responds with an error" do
        response = described_class.call(params: { first_name: "John", last_name: 1 })

        expect(response.success?).to be false
        expect(response.status).to eq :unprocessable_entity
        expect(response.data).to eq(message: "User not created")
        expect(response.errors).to eq(last_name: ["must be a string"])
      end
    end
  end
end
