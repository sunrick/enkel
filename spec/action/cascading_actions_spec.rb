module CascadingActions
  class OnboardUser < Enkel::Action
    def initialize(email:, organization_name:)
      @email = email
      @organization_name = organization_name
    end

    def call
      merge! CreateUser.call(email: @email)
      merge! CreateOrganization.call(name: @organization_name)

      NotifyAdmins.call(
        user: data[:user],
        organization: data[:organization]
      ) do |r|
        if r.success?
          data[:notify_admins] = r.data
        else
          error! r.errors
        end
      end
    end
  end

  class CreateUser < Enkel::Action
    def initialize(email:)
      @email = email
    end

    def call
      if @email == "valid@gmail.com"
        respond user: { email: @email }
      else
        error email: "invalid email"
      end
    end
  end

  class CreateOrganization < Enkel::Action
    def initialize(name:)
      @name = name
    end

    def call
      if @name == "valid_name"
        respond organization: { name: @name }
      else
        error name: "invalid name"
      end
    end
  end

  class NotifyAdmins < Enkel::Action
    def initialize(user:, organization:)
      @user = user
      @organization = organization
    end

    def call
      respond message: "Admins notified"
    end
  end
end

RSpec.describe CascadingActions::OnboardUser do
  context "when given valid params" do
    it "creates a user" do
      response =
        described_class.call!(
          email: "valid@gmail.com",
          organization_name: "valid_name"
        )

      expect(response.success?).to be(true)
      expect(response.status).to eq(:ok)
      expect(response.data).to eq(
        user: {
          email: "valid@gmail.com"
        },
        organization: {
          name: "valid_name"
        },
        notify_admins: {
          message: "Admins notified"
        }
      )
    end
  end

  context "when given invalid email" do
    it "errors" do
      response =
        described_class.call!(
          email: "invalid@gmail.com",
          organization_name: "valid_name"
        )
      expect(response.success?).to be(false)
      expect(response.status).to eq(:unprocessable_entity)
      expect(response.data).to eq({})
      expect(response.errors).to eq(email: ["invalid email"])
    end
  end

  context "when given invalid organization_name" do
    it "errors" do
      response =
        described_class.call!(
          email: "valid@gmail.com",
          organization_name: "invalid_name"
        )
      expect(response.success?).to be(false)
      expect(response.status).to eq(:unprocessable_entity)
      expect(response.data).to eq(user: { email: "valid@gmail.com" })
      expect(response.errors).to eq(name: ["invalid name"])
    end
  end
end
